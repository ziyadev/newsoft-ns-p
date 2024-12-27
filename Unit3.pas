unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,DelphiZXingQRCode,
  Vcl.ComCtrls,Math, REST.Types, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client, System.JSON, Vcl.WinXCtrls,Unit2, Unit4, ShellAPI,System.Threading;

type
  TUserDetails = class
  private
    FId: string;
    FEmail: string;
    FFirstName: string;
    FLastName: string;
    FCreatedAt: string;
    FSessionToken: string;
  public
    constructor Create(const AId, AEmail, AFirstName, ALastName, ACreatedAt, ASessionToken: string);
    property Id: string read FId write FId;
    property Email: string read FEmail write FEmail;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
    property CreatedAt: string read FCreatedAt write FCreatedAt;
    property SessionToken: string read FSessionToken write FSessionToken;
  end;
  TMaster = class(TForm)
    Panel1: TPanel;
    StaticText1: TStaticText;
    Label1: TLabel;
    TQrCodeImage: TImage;
    RESTClient1: TRESTClient;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    ValidateSessionButton: TButton;
    ProgressBar1: TProgressBar;
    Button2: TButton;
    VisitAuthButton: TButton;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ValidateSessionButtonClick(Sender: TObject);
    procedure VisitAuthButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function  ValidateUserSession(SessionId:string):String;
    procedure GenerateAuthenticationQRCode(Image: TImage);
    function  AuthenticateAndGetUserDetails(Token:string):TUserDetails;
  end;

var
  Master: TMaster;
   AuthUrl: string;
   SessionId:string;

implementation

{$R *.dfm}
procedure TMaster.GenerateAuthenticationQRCode(Image: TImage);

var
  QRCode: TDelphiZXingQRCode;
  Row, Col: Integer;
  CellSize, ImageWidth, ImageHeight: Integer;
  ScaleFactor: Single;
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  Response: TJSONObject;

begin
  RESTClient := TRESTClient.Create('https://newsoft-board.vercel.app/api/STOCK');
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  QRCode := TDelphiZXingQRCode.Create;
  Response := nil;
  try
    try
      // Set up REST components
      RESTRequest.Client := RESTClient;
      RESTRequest.Response := RESTResponse;
      RESTRequest.Resource := 'generate-session-id';
      RESTRequest.Method := rmPOST;

      // Execute the request
      RESTRequest.Execute;

      // Parse the response JSON
      Response := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
      if Assigned(Response) and Assigned(Response.Values['data']) and
         (Response.Values['code'].Value = 'SUCCESS') then
      begin
        SessionId:=Response.Values['data'].Value;
        AuthUrl := Format('https://newsoft-board.vercel.app/app-link?sessionId=%s', [SessionId]);
      end
      else
      begin
        ShowMessage('Invalid response: "data" not found in JSON');
      end;
    except
      on E: Exception do
      begin
        ShowMessage('An error occurred during REST request: ' + E.Message);
        Exit; // Exit if REST request fails
      end;
    end;
  finally
    RESTRequest.Free;
    RESTResponse.Free;
    RESTClient.Free;
    Response.Free;
  end;

  // QR Code generation logic
  try
    QRCode.Data := AuthUrl;
    QRCode.Encoding := TQRCodeEncoding.qrAuto;

    // Get the size of the TImage component
    ImageWidth := Image.Width;
    ImageHeight := Image.Height;

    // Calculate the scale factor to fit the QR code inside the image
    ScaleFactor := Min(ImageWidth, ImageHeight) / Max(QRCode.Rows, QRCode.Columns);

    // Calculate the cell size based on the scale factor
    CellSize := Round(ScaleFactor);

    // Resize the bitmap to fit the QR code
    Image.Picture.Bitmap.SetSize(ImageWidth, ImageHeight);
    Image.Picture.Bitmap.Canvas.Brush.Color := clWhite;
    Image.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, ImageWidth, ImageHeight));

    // Set the brush color to black for QR code cells
    Image.Picture.Bitmap.Canvas.Brush.Color := clBlack;

    // Draw the QR code on the image
    for Row := 0 to QRCode.Rows - 1 do
      for Col := 0 to QRCode.Columns - 1 do
        if QRCode.IsBlack[Row, Col] then
          Image.Picture.Bitmap.Canvas.FillRect(
            Rect(Col * CellSize, Row * CellSize, (Col + 1) * CellSize, (Row + 1) * CellSize)
          );


  finally
  begin
    QRCode.Free;
  end;
  end;
end;
function TMaster.ValidateUserSession(SessionId: string):String;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  Response: TJSONObject;
  DataObject: TJSONObject;
begin
  RESTClient := TRESTClient.Create('https://newsoft-board.vercel.app/api/STOCK');
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  Response := nil;
  DataObject:=nil;

  try
  begin
    // Set up REST components
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := Format('verify-session-id?sessionId=%s', [SessionId]);
    RESTRequest.Method := rmPOST;

    // Execute the request
    RESTRequest.Execute;

    // Parse the response JSON
    Response := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
    if Assigned(Response) then
    begin
      // Check the HTTP status code
      if RESTResponse.StatusCode = 201 then // Session is valid and auth token is generated
      begin
        // Handle the success response, parse the token or other data as needed
        if Assigned(Response.Values['data']) and (Response.Values['data'] is TJSONObject) then
        begin
          // We get the token from data object
          // First set the Data on dataObject
          DataObject := Response.Values['data'] as TJSONObject;
          Result := DataObject.Values['token'].Value;


        end
      end
      else if RESTResponse.StatusCode = 401 then // Session ID missing or not validated yet
      begin
         if (Response.Values['code'].Value = 'SESSION_PENDING') then
         raise Exception.Create('Session not validated yet.')
         else
         raise Exception.Create('Session ID missing.');
      end
      else if RESTResponse.StatusCode = 403 then // Session does not exist, expired or invalid
      begin
         raise Exception.Create('Session does not exist, expired, or invalid.');

      end
      else if RESTResponse.StatusCode = 500 then // Server error
      begin
     raise Exception.Create('Server error occurred. Please try again later.');

      end
      else // Handle unexpected status codes
      begin
        raise Exception.Create('Unexpected error occurred. Status code: ');

      end;
    end
    else
    begin
      raise Exception.Create('Failed to parse the response or no response received.');

    end;
  end;
  finally
    // Clean up
    RESTRequest.Free;
    RESTResponse.Free;
    RESTClient.Free;
    Response.Free;
      // We need this token to authenticate every time we want to
  end;
end;
function TMaster.AuthenticateAndGetUserDetails(Token:string):TUserDetails;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  Response: TJSONObject;
  ResponseData: TJSONObject;
  DataObject:TJSONObject;
  DeviceDetails: TJSONObject;
  UserDetails: TUserDetails;
begin
  RESTClient := TRESTClient.Create('https://newsoft-board.vercel.app/api/STOCK');
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  Response := nil;
  Result := nil;
  DataObject := nil;
  UserDetails := nil;
  try
   // Set up REST components
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := Format('authenticate?token=%s',[Token]);
    RESTRequest.Method := rmPOST;
    
    DeviceDetails := TJSONObject.Create;
    // we have to specify the real  device information
    DeviceDetails.AddPair('deviceId', '123456789');
    DeviceDetails.AddPair('deviceName', 'DESKTOP_EX_12');
    DeviceDetails.AddPair('deviceType', 'Desktop');
    DeviceDetails.AddPair('deviceOs', 'Windows 11 pro');
    DeviceDetails.AddPair('deviceOsVersion', '22.20');
    DeviceDetails.AddPair('deviceModel', 'Asus');
     // Add the device details to the body
    RESTRequest.AddBody(DeviceDetails.ToString, TRESTContentType.ctAPPLICATION_JSON);

     // Execute the request a lkhalilo
    RESTRequest.Execute;






    if RESTResponse.StatusCode = 200 then // Authentication seccessful
    begin
       // Parse the response JSON
      Response := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
    if Assigned(Response.Values['data']) and (Response.Values['data'] is TJSONObject) then
      begin

      DataObject := Response.Values['data'] as TJSONObject;
      // Now extract details from DataObject to create UserDetails
      UserDetails := TUserDetails.Create(
      DataObject.Values['id'].Value,
      DataObject.Values['email'].Value,
      DataObject.Values['firstName'].Value,
      DataObject.Values['lastName'].Value,
      DataObject.Values['createdAt'].Value, // Same as joined at
      Token
      )

      end;

    end
    else if (RESTResponse.StatusCode = 400) or (RESTResponse.StatusCode = 401) then // Invalid input or  authentication failed due token expires or invalidation
         begin
           raise Exception.Create('Invalid input or authentication failed. Token may be expired or invalid.');


         end
    else if RESTResponse.StatusCode = 403 then // Invalid input or  authentication failed due token expires or invalidation
         begin
           raise Exception.Create('No active subscription or devices limit exceeded.');
          end

    else
    begin
       raise Exception.Create('Something wrong happen, please try again later.');

    end;



  finally
     begin
      RESTRequest.Free;
      RESTResponse.Free;
      RESTClient.Free;
      // Return the UserDetails object if found, otherwise kepp it nil
      Result := UserDetails;
     end;
  end;



end;
constructor TUserDetails.Create(const AId, AEmail, AFirstName, ALastName, ACreatedAt, ASessionToken: string);
begin
  FId := AId;
  FEmail := AEmail;
  FFirstName := AFirstName;
  FLastName := ALastName;
  FCreatedAt := ACreatedAt;
  FSessionToken := ASessionToken;
end;
// Authentication section starts ends;










procedure TMaster.ValidateSessionButtonClick(Sender: TObject);
var
  AuthToken: String;
begin
  SessionVForm := TSessionVForm.Create(Self);
  SessionVForm.Show;
  try
    TTask.Run(procedure
    begin
      try
        // Call the API in a background thread
        TThread.Synchronize(nil, procedure
        begin
          SessionVForm.Label1.Caption := 'Validating session...';
        end);

        AuthToken := ValidateUserSession(SessionId); // This might raise an exception

        TThread.Synchronize(nil, procedure
        begin
          SessionVForm.Label1.Caption := 'Authenticating and getting user details...';
        end);

        AuthenticateAndGetUserDetails(AuthToken); // This might also raise an exception

        TThread.Synchronize(nil, procedure
        begin
          SessionVForm.Close; // Close the form after successful completion

            ActivationSuccess := TActivationSuccess.Create(Self);
            ActivationSuccess.Show;
        end);
      except
        on E: Exception do
        begin
          // Catch exceptions and show an error dialog
          TThread.Synchronize(nil, procedure
          begin
            MessageDlg('Error: ' + E.Message, mtError, [mbOK], 0);
            SessionVForm.Close; // Ensure the form is closed if an error occurs
          end);
        end;
      end;
    end);
  except
    on E: Exception do
    begin
      // Handle exceptions at the outer level
      MessageDlg('An error occurred in the main procedure: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;


procedure TMaster.VisitAuthButtonClick(Sender: TObject);
begin
 ShellExecute(0, 'OPEN', PChar(AuthUrl), nil, nil, SW_SHOWNORMAL);
end;

procedure TMaster.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TMaster.FormCreate(Sender: TObject);
begin
    TTask.Run(procedure
    begin
       // Perform the QR code generation in a separate thread
        GenerateAuthenticationQRCode(TQrCodeImage);
      // Update UI in the main thread after the API call
      TThread.Synchronize(nil, procedure
      begin
      ProgressBar1.Visible := False; // Hide the loading bar
      TQrCodeImage.Visible := True; // Show the generated QR code
      ValidateSessionButton.Enabled := TRUE ;
      VisitAuthButton.Enabled := TRUE ;
      end);
    end);

end;





end.
