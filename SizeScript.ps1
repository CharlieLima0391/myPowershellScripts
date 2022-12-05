function Count-Data{


Get-ChildItem -Recurse -ErrorAction SilentlyContinue | 
Measure-Object -Property Length -Sum | 
Select-Object Sum, Count

}
