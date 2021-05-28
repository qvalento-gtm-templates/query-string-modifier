# Query String Modifier

This template will extract the query string from a URL and return it as it is or as modified version, depending on user choices. Here are a few examples of what you as a user can do:

- Decide if the query string should be returned with a leading question mark or not.
- Add parameters to a whitelist. All other parameters will be modified.
- Insert a custom text string as a replacement for all query parameters that are not in your whitelist.
- Remove parameters that you don't want to include in the query string.

With these functions, you can make sure that you are not sending any PII to Google Analytics from the query string. The reason why you should use a whitelist instead of excluding specific parameters is that you might not be able to control if there are new parameters added to the website which might send data to your account before you find out, and then it would already be too late.


## Example where we choose to keep all UTM
https://lynuhs.com/?utm_source=github&utm_medium=social&email=dummy@lynuhs.com

### With redaction
?utm_source=github&utm_medium=social&email=[REDACTED]

### With removal
?utm_source=github&utm_medium=social
