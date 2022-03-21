Class dc.GblToJSON.EX
{
ClassMethod export(gref As %String = "^%", file = "gbl.json") As %String
{
	new %gref,%file
	set %gref=gref,%file=file
	open %file:("WNS"):1 
	else  quit "File failed to create"
	use %file write "{""gbl"":["
	if $d(@%gref) do ..jsondump()
	use %file write !,"]}",!
	close %file 
	quit "File "_%file_" created"
}

ClassMethod jsondump() As %String
{
	set node=..node()
	use %file
	write !,node
	for  {
		set node=$q(@$ZR) quit:node=""
		set node=..node()
		use %file
		write ",",!,node	
		}
	quit 1
}

ClassMethod node() As %String
{
	set d=$d(@$ZR,val)
	set node={}
	if d set node.node=$ZR
	if d#2 {
		if $lv(val) set val=..lb(val)
		set node.val=val 
		}
	 quit node.%ToJSON()
}

ClassMethod lb(val = "") As %String
{
#define topspool 99999
	new %zsp
	set %zsp=$zr
	open 2:$$$topspool use 2 zwrite val close 2
	set lb=^SPOOL($$$topspool,1)
	set lb=$replace(lb,$c(27)_"[22m","")
	set lb=$replace(lb,$c(27)_"[1m","")
	set lb=$tr(lb,$c(13,10))
	set lb=$e(lb,5,*)
	if $d(@%zsp)
	quit lb
}

ClassMethod show(file = "gbl.json") As %String
{
	open file:("R"):1
	else  quit "File not found"
	set $ZT="end"
	for { 
		use file read line
		use 0 write line,!
		if line="]}" quit
		}
end
	close file	
	quit "***** "_file_" *****"
}

ClassMethod import(file = "gbl.json") As %String
{
	new %node
	open file:("R"):1
	else  quit "File not found"	
	use file read line
	if line'= "{""gbl"":[" close file quit "File format error"
	for {
		use file 
		read line
		if line="]}" set sc=1 quit
		if $e(line,*)="," set line=$e(line,1,*-1)
		set obj={}.%FromJSON(line)
		if obj.%IsA("%Library.DynamicObject") {
			set %node=obj.node
			set val=obj.val
			if $e(val,1,4)="$lb(" {
				set %node=%node_"="_val
				set @%node
			} else  {
				set @%node=val 
				}  
			}
		else  {
			set sc=0 quit 
			}	
		}
	close file	
	quit:sc "Global "_$qs($zr,0)_" loaded"
	quit "Global load broken"
}

}
