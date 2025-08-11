# locationcomparewithcoordinates

A new Flutter project.

## Getting Started






___
___
___
# How to add Set Data In Google Sheet By Flutter
---
## Google Sheets-এ Google Apps Script সেটআপ করা
- Google Sheets ফাইল ওপেন করুন।
- Menu থেকে Extensions > Apps Script ওপেন করুন।
- নিচের কোড Apps Script editor-এ কপি-পেস্ট করুন:


```javascript
    function doPost(e) {
      try {
        var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
        var data = JSON.parse(e.postData.contents);
        sheet.appendRow([data.name, data.email, data.message]);
        return ContentService.createTextOutput(JSON.stringify({status: "success"})).setMimeType(ContentService.MimeType.JSON);
      } catch (err) {
        return ContentService.createTextOutput(JSON.stringify({status: "error", message: err.message})).setMimeType(ContentService.MimeType.JSON);
      }
    }
```

- Add This Code Android Studio.

```dart
    Future<void> sendToGoogleSheet(String name, String email, String message) async {
        setState(() {_isLoading = true;});
    
        final url = Uri.parse("Web App Deployment URL");
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "email": email,
            "message": message,
          }),
        );
    
        if(response.statusCode == 302){
          if(mounted){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.check_circle_outline_rounded),
                      SizedBox(width: 10,),
                      Text('Update'),
                    ],
                  ),
                  content: Text('Successfully Update Data'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
        setState(() {_isLoading = false;});
      }
```


- Deploy > New Deployment ক্লিক করুন।
- Deployment type হিসেবে Web app নির্বাচন করুন।
- Access কে দিন Anyone
- Deploy করুন, তাহলে একটা URL পাবেন, যেটা হলো আপনার API endpoint