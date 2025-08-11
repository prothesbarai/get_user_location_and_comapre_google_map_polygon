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
        var data = JSON.parse(e.postData.contents);
        var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('MySheet');
    
        // ধরো name, email, message কলাম যথাক্রমে ১, 2, 3 কলামে রাখতে চাই  (row 2 থেকে শুরু)
        var lastRow = sheet.getLastRow() + 1; 
    
        sheet.getRange(lastRow, 1).setValue(data.name);
        sheet.getRange(lastRow, 2).setValue(data.email);
        sheet.getRange(lastRow, 3).setValue(data.message);
    
        return ContentService.createTextOutput(JSON.stringify({status: "success"})).setMimeType(ContentService.MimeType.JSON);
      } catch (err) {
        return ContentService.createTextOutput(JSON.stringify({status: "error", message: err.message})).setMimeType(ContentService.MimeType.JSON);
      }
    }
```
---
# OR
---
## যদি ডুপ্লিকেট পাওয়া যায়, তখন ঐ row-তে আপডেট হবে; আর যদি না থাকে, তাহলে নতুন একটা row-তে ডাটা ঢুকবে।
```javascript
    function doPost(e) {
      try {
        var data = JSON.parse(e.postData.contents);
        var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('MySheet');
    
        // হেডার চেক (১ম সারি, ৬ কলাম)
        var header = sheet.getRange(1, 1, 1, 6).getValues()[0];
        var expectedHeader = ["Name", "Latitude", "Longitude", "LocationName", "LocationId", "CountryCode"];
        var headerMismatch = false;
    
        for (var i = 0; i < expectedHeader.length; i++) {
          if (header[i] !== expectedHeader[i]) {
            headerMismatch = true;
            break;
          }
        }
    
        if (headerMismatch) {
          sheet.getRange(1, 1, 1, 6).setValues([expectedHeader]);
        }
    
        var lastRow = sheet.getLastRow();
        var allData = [];
    
        if (lastRow > 1) {
          allData = sheet.getRange(2, 1, lastRow - 1, 6).getValues();
        }
    
        // helper function: string এ কনভার্ট করে ট্রিম করবে
        function clean(val) {
          if (val === null || val === undefined) return "";
          return String(val).trim();
        }
    
        // ইনকামিং ডাটা ক্লিন করা
        var incoming = [
          clean(data.name),
          clean(data.latitude),
          clean(data.longitude),
          clean(data.locationName),
          clean(data.locationId),
          clean(data.countryCode)
        ];
    
        var duplicateRow = null;
    
        for (var i = 0; i < allData.length; i++) {
          var row = allData[i].map(clean); // শিটের রোও ট্রিম ও স্ট্রিং করা
          var isSame = true;
          for (var j = 0; j < 6; j++) {
            if (row[j] !== incoming[j]) {
              isSame = false;
              break;
            }
          }
          if (isSame) {
            duplicateRow = i + 2;
            break;
          }
        }
        
        
        
        /*
        // ★★ important part: If You Only Duplicate Check by LocationId ★★ Replace Only For Loop.. Other Condition Same to same
        for (var i = 0; i < allData.length; i++) {
          var rowLocationId = clean(allData[i][4]); // ৫ম কলাম = LocationId
          if (rowLocationId === incoming[4]) {
            duplicateRow = i + 2;  // শীটে রো নম্বর
            break;
          }
        }
        */
        
        
    
        if (duplicateRow !== null) {
          // ডুপ্লিকেট হলে আপডেট করো (তুমি চাইলে আপডেট না করেও পারো)
          sheet.getRange(duplicateRow, 1).setValue(data.name);
          sheet.getRange(duplicateRow, 2).setValue(data.latitude);
          sheet.getRange(duplicateRow, 3).setValue(data.longitude);
          sheet.getRange(duplicateRow, 4).setValue(data.locationName);
          sheet.getRange(duplicateRow, 5).setValue(data.locationId);
          sheet.getRange(duplicateRow, 6).setValue(data.countryCode);
    
          return ContentService.createTextOutput(JSON.stringify({status: "updated", row: duplicateRow})).setMimeType(ContentService.MimeType.JSON);
        } else {
          // নতুন row এ ডাটা ঢোকাও
          var newRow = lastRow + 1;
          sheet.getRange(newRow, 1).setValue(data.name);
          sheet.getRange(newRow, 2).setValue(data.latitude);
          sheet.getRange(newRow, 3).setValue(data.longitude);
          sheet.getRange(newRow, 4).setValue(data.locationName);
          sheet.getRange(newRow, 5).setValue(data.locationId);
          sheet.getRange(newRow, 6).setValue(data.countryCode);
    
          return ContentService.createTextOutput(JSON.stringify({status: "inserted", row: newRow})).setMimeType(ContentService.MimeType.JSON);
        }
    
      } catch (err) {
        return ContentService.createTextOutput(JSON.stringify({status: "error", message: err.message})).setMimeType(ContentService.MimeType.JSON);
      }
    }
```
- প্রথমে allData তে সব ডাটা নিয়ে আসলাম।
- তারপর চেক করলাম, আগের ডাটা এর সাথে কি পুরো মিল আছে।
- যদি মিলে যায়, duplicateRow সেট করলাম ঐ row নম্বর (Google Sheet এ ২য় সারো থেকে ডাটা শুরু তাই i+2)।
- ডুপ্লিকেট থাকলে ঐ row-তে ডাটা আপডেট করলাম।
- না থাকলে, নতুন row (lastRow + 1) তে ডাটা ঢুকালাম।
- রেসপন্সে status এবং row নম্বর JSON আকারে রিটার্ন করলাম।


---
---
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