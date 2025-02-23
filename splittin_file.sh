#!/bin/bash
#this is a script designed to copy various filetypes from a directory tree and sort into
#new folders deliminated by last modified timestamp. No files are deleted or moved

#usefull for sifting through garbage files after recovering dead drive data with "Photorec" software

declare -A sort_type

sort_type["archive"]=".7z|.a|.ace|.apk|.arj|.bkf|.bz2|.cab|.dar|.deb|.dump|.ghx|.gz|.lzh|.lzo|.par2|.rar|.rpm|.stu|.tar|.tar.gz|.vbm|.wim|.xar|.xz|.zip"

sort_type["multimedia"]=".3ds|.3dm|.3g2|.3gp|.abr|.acb|.ado|.aep|.afdesign|.aif|.albm|.all|.als|.ani|.ape|.ari|.arw|.asf,|.asl|.au|.avi|.axp|.binvox|.bdm|.bld|.blend|.bmp|.bpg|.bvr|.c4d|.caf|.cam|.camrec|.CATDrawing|.cda|.cdd|.cdl|.cdr|.cdt|.celtx|.che|.comicdoc|.cpi|.cpr|.cr2|.cr3|.crw|.csh|.ctg|.cue|.dad|.db|.dcm|.dcr|.djv|.dng|.dp|.dpx|.ds2|.dsc|.dss|.ds_store|.dta|.dv|.dvi|.dvr|.dwg|.emf|.epub|.ers|.exs|.fcp|.fh10|.fh5|.flac|.fla|.flp|.flv|.gi|.gif|.gp4|.gp5|.gpx|.gsm|.heic|.icc|.icns|.ico|.idf|.idx|.iff|.ind|.ifo|.indd|.info|.ipt|.iso|.it|.itu|.ora|.jng|.jpg|.jpg|.kra|.logic|.m2t|.m2ts|.m3u|.m4p|.max|.max|.mb|.mcf|.mfa|.mhbd|.mid|.mkv|.mlv|.mng|.mov|.mp|.mp3|.mp4|.mpg|.mpl|.mpo|.mrw|.mus|.mws|.nef|.oci|.ogg|.ogm|.ogv|.orf|.pbm|.pct|.pcx|.psb|.pef|.pgm|.png|.pnm|.ppm|.prproj|.psd|.psf|.psp|.ptb|.pts|.pvp|.qcp|.qkt|.qxd|.qxp|.r3d|.raf|.ram|.ra|.raw|.rdc|.rm|.rns|.rns|.rpp|.rw2|.rx2|.ses|.shn|.sib|.sit|.skd|.sketch|.smil|.spss|.sr2|.svg|.swc|.swf|.tg|.tif|.TiVo|.tod|.tpl|.ts|.vdj|.wav|.wdp|.webm|.webp|.wee|.wmf|.wnk|.wpb|.wpl|.wtv|.wv|.x3f|.x3i|.xcf|.xd|.xm|.xmp|.xrns|.xv|.zcode"

sort_type["office"]=".pdf|.accdb|.ai|.apr|.csv|.cwk|.doc|.docx|.et|.fb2|.fods|.fp7|.fp12|.gnucash|.kmy|.lyx|.mdb|.njx|.odg|.odp|.ods|.odt|.one|.pages|.pap|.ppt|.pptx|.pub|.qbb|.qbw|.qpw|.rtf|.sda|.sdc|.sdd|.sdw|.slk|.sav|.snt|.sxc|.sxd|.sxi|.sxw|.tex|.txt|.vsd|.vsdx|.wpd|.wps|.xlr|.xls|.xlsx|.wdb|.wk4|.wks"

sort_type["other"]=".1cd|.ab|.adr|.agn|.ahn|.amb|.amd|.amr|.amt|.apa|.apple|.asm|.asp|.atd|.atd|.att|.axx|.bac|.bai|.bam|.bat|.bgz|.bim|.c|.chm|.class|.cls|.cm|.compress|.cow|.cp_|.csi|.d2s|.dat|.dbf|.dbn|.dbx|.dc|.ddf|.dex|.dgn|.dif|.dim|.diskimage|.dll|.dmp|.drw|.dsa|.dst|.dxf|.e01|.ecr|.eCryptfs|.edb|.elf|.emb|.emka|.emlx|.eps|.ess|.evt|.evtx|.exe|.fbf|.fbk|.fcs|.fdb|.fds|.f|.fh1|.fit|.fits|.fm|.fob|.fos|.fp5|.freeway|.frm|.frm|.fst|.fs|.fwd|.gam|.gcs|.gct|.gho|.gm6|.gm81|.gmd|.gmk|.gp2|.gpg|.gsb|.h|.hdf|.hdr|.hds|.hm|.hr9|.html.gz|.html|.http|.ibd|.ics|.imb|.img|.imm|.inf|.ini|.jad|.jar|.jks|.jnb|.jp2|.json|.jsonlz4|.jsp|.kdb|.kdbx|.key|.kmz|.ldf|.ldif|.lit|.lnk|.lso|.luks|.lwo|.lxo|.ly|.mat|.mcd|.mdf|.mdl|.mem|.mfg|.mig|.mk5|.mmap|.mny|.mobi|.msa|.msf|.msg|.mxf|.MYI|.myo|.nd2|.nds|.nes|.nk2|.notebook|.nsf|.p65|.paf|.pcap|.pcb|.pcp|.pdb|.pdf|.pds|.pf|.pfx|.pgp|.php|.pli|.plist|.pl|.plt|.pm|.ppk|.prc|.prd|.priv|.prt|.psmodel|.ps|.pst|.ptf|.ptx|.pub|.pub|.pyc|.py|.pzf|.pzh|.qbb|.qbmb|.qbw|.qdf-backup|.qdf|.qgs|.rb|.RData|.reg|.res|.rfp|.rlv|.rsa|.rvt|.save|.schematic|.sgcta|.sh3d|.sh|.skp|.sla|.sldprt|.sld|.snag|.sp3|.sparseimage|.spe|.spf|.sqlite|.sql|.sqm|.steuer2014|.steuer2015|.stl|.stp|.studio|.tax|.tcw|.tib|.ticket.bin|.torrent|.tph|.ttd|.ttf|.tz|.url|.v2i|.vault|.vb|.vcf|.vdi|.veg|.vfb|.vib|.wallet|.vmdk|.vmg|.wab|.wim|.win|.wld|.woff|.x4a|.x4g|.x4p|.x4s|.xfi|.xml.gz|.xml|.xoj|.xpi|.xpt|.xsv|.z2d|.zpr"

sort_type["all"]=".1cd|.ab|.adr|.agn|.ahn|.amb|.amd|.amr|.amt|.apa|.apple|.asm|.asp|.atd|.atd|.att|.axx|.bac|.bai|.bam|.bat|.bgz|.bim|.c|.chm|.class|.cls|.cm|.compress|.cow|.cp_|.csi|.d2s|.dat|.dbf|.dbn|.dbx|.dc|.ddf|.dex|.dgn|.dif|.dim|.diskimage|.dll|.dmp|.drw|.dsa|.dst|.dxf|.e01|.ecr|.eCryptfs|.edb|.elf|.emb|.emka|.emlx|.eps|.ess|.evt|.evtx|.exe|.fbf|.fbk|.fcs|.fdb|.fds|.f|.fh1|.fit|.fits|.fm|.fob|.fos|.fp5|.freeway|.frm|.frm|.fst|.fs|.fwd|.gam|.gcs|.gct|.gho|.gm6|.gm81|.gmd|.gmk|.gp2|.gpg|.gsb|.h|.hdf|.hdr|.hds|.hm|.hr9|.html.gz|.html|.http|.ibd|.ics|.imb|.img|.imm|.inf|.ini|.jad|.jar|.jks|.jnb|.jp2|.json|.jsonlz4|.jsp|.kdb|.kdbx|.key|.kmz|.ldf|.ldif|.lit|.lnk|.lso|.luks|.lwo|.lxo|.ly|.mat|.mcd|.mdf|.mdl|.mem|.mfg|.mig|.mk5|.mmap|.mny|.mobi|.msa|.msf|.msg|.mxf|.MYI|.myo|.nd2|.nds|.nes|.nk2|.notebook|.nsf|.p65|.paf|.pcap|.pcb|.pcp|.pdb|.pdf|.pds|.pf|.pfx|.pgp|.php|.pli|.plist|.pl|.plt|.pm|.ppk|.prc|.prd|.priv|.prt|.psmodel|.ps|.pst|.ptf|.ptx|.pub|.pub|.pyc|.py|.pzf|.pzh|.qbb|.qbmb|.qbw|.qdf-backup|.qdf|.qgs|.rb|.RData|.reg|.res|.rfp|.rlv|.rsa|.rvt|.save|.schematic|.sgcta|.sh3d|.sh|.skp|.sla|.sldprt|.sld|.snag|.sp3|.sparseimage|.spe|.spf|.sqlite|.sql|.sqm|.steuer2014|.steuer2015|.stl|.stp|.studio|.tax|.tcw|.tib|.ticket.bin|.torrent|.tph|.ttd|.ttf|.tz|.url|.v2i|.vault|.vb|.vcf|.vdi|.veg|.vfb|.vib|.wallet|.vmdk|.vmg|.wab|.wim|.win|.wld|.woff|.x4a|.x4g|.x4p|.x4s|.xfi|.xml.gz|.xml|.xoj|.xpi|.xpt|.xsv|.z2d|.zpr|.accdb|.ai|.apr|.csv|.cwk|.doc|.docx|.et|.fb2|.fods|.fp7|.fp12|.gnucash|.kmy|.lyx|.mdb|.njx|.odg|.odp|.ods|.odt|.one|.pages|.pap|.ppt|.pptx|.pub|.qbb|.qbw|.qpw|.rtf|.sda|.sdc|.sdd|.sdw|.slk|.sav|.snt|.sxc|.sxd|.sxi|.sxw|.tex|.txt|.vsd|.vsdx|.wpd|.wps|.xlr|.xls|.xlsx|.wdb|.wk4|.wks|.3ds|.3dm|.3g2|.3gp|.abr|.acb|.ado|.aep|.afdesign|.aif|.albm|.all|.als|.ani|.ape|.ari|.arw|.asf,|.asl|.au|.avi|.axp|.binvox|.bdm|.bld|.blend|.bmp|.bpg|.bvr|.c4d|.caf|.cam|.camrec|.CATDrawing|.cda|.cdd|.cdl|.cdr|.cdt|.celtx|.che|.comicdoc|.cpi|.cpr|.cr2|.cr3|.crw|.csh|.ctg|.cue|.dad|.db|.dcm|.dcr|.djv|.dng|.dp|.dpx|.ds2|.dsc|.dss|.ds_store|.dta|.dv|.dvi|.dvr|.dwg|.emf|.epub|.ers|.exs|.fcp|.fh10|.fh5|.flac|.fla|.flp|.flv|.gi|.gif|.gp4|.gp5|.gpx|.gsm|.heic|.icc|.icns|.ico|.idf|.idx|.iff|.ind|.ifo|.indd|.info|.ipt|.iso|.it|.itu|.ora|.jng|.jpg|.jpg|.kra|.logic|.m2t|.m2ts|.m3u|.m4p|.max|.max|.mb|.mcf|.mfa|.mhbd|.mid|.mkv|.mlv|.mng|.mov|.mp|.mp3|.mp4|.mpg|.mpl|.mpo|.mrw|.mus|.mws|.nef|.oci|.ogg|.ogm|.ogv|.orf|.pbm|.pct|.pcx|.psb|.pef|.pgm|.png|.pnm|.ppm|.prproj|.psd|.psf|.psp|.ptb|.pts|.pvp|.qcp|.qkt|.qxd|.qxp|.r3d|.raf|.ram|.ra|.raw|.rdc|.rm|.rns|.rns|.rpp|.rw2|.rx2|.ses|.shn|.sib|.sit|.skd|.sketch|.smil|.spss|.sr2|.svg|.swc|.swf|.tg|.tif|.TiVo|.tod|.tpl|.ts|.vdj|.wav|.wdp|.webm|.webp|.wee|.wmf|.wnk|.wpb|.wpl|.wtv|.wv|.x3f|.x3i|.xcf|.xd|.xm|.xmp|.xrns|.xv|.zcode|.7z|.a|.ace|.apk|.arj|.bkf|.bz2|.cab|.dar|.deb|.dump|.ghx|.gz|.lzh|.lzo|.par2|.rar|.rpm|.stu|.tar|.tar.gz|.vbm|.wim|.xar|.xz|.zip"


set -xv
[ "${BASH_VERSINFO:-0}" -ge 4 ] || { echo "This script requires bash to be a minimum version 4.2 to function properly";exit 1; }

while getopts hed:t:  opt; do
	case ${opt} in
	d)
		delim="${OPTARG}" ;;
	t)
		sort_selection="${OPTARG}" ;;
	e)
		sort_file_extension="on" ;;

	h)
		echo "
Usage: $(basename $0) [OPTIONS]

Options:
  -e				Sort the found files into folders by the file extension
  -d,				Specify a Custom Date deliminator. Separate each %b/%y/%a with a / to make custom subfolders to sort into
  -h,				Print this help menu
  -t,				Select the type of files you are looking for: archive, office, other, all, multimedia
"
		exit ;;
	:)
      		echo "Option -${OPTARG} requires an argument."
     		 exit 1 ;;
	?)
		echo "Invalid option: -${OPTARG}."
		exit 1 ;;


	esac
done

#default options if you run without switches
[  -z "$delim" ] && delim="%Y"
[  -z "$sort_type" ] && key_selection="office"

for key in ${!sort_type[@]};do
	[[ "$sort_selection" = "$key" ]] && key_selection=$key
done

while :
do
	read -p "What is the exact file path? :" path_to_files
	clear
	read -n 1 -p "Is this the correct path [Y/N]: $path_to_files" opt
	clear
	case $opt in
		[Yy])
			[ -d "$path_to_files" ] && { break; }
			echo "not valid path please try again"
			echo "";;

		[Nn])
			clear;;
		*)
			clear
			echo "oops sorry, that is not a valid choice"
			echo -en "\n\n\t\t\tHit any key to continue"
			read -n 1 option
			clear;;
	esac
done


CheckDateSort() {
	[[ $sort_file_extension = "on" ]] && file_extension=$( echo $1 | awk -F. '{print $(NF)}')
	check_date=$(date -r $1 +$delim)
	file_date_path="$file_folder$file_extension/$check_date"
	if [[ -d "$file_date_path" ]];
	then
		cp -a $1 $file_date_path
	else
		mkdir -p $file_date_path && cp -a $1 $file_date_path
	fi
}

#Checks for any additional trailing / greater than 1 at the end of the path and deletes them
[[ "$path_to_files" =~ .*"/?"$ ]] || path_to_files=$(echo $path_to_files|sed 's!/*$!!')

#checks for a trailing / and adds one if not found
[[ "$path_to_files" =~ .*"/"$ ]] || path_to_files+="/"

file_folder="$path_to_files"ALL_FILES/

#iregex is case inse -type f nsitive -regex
find $path_to_files -type f -regextype posix-egrep -iregex ".*(${sort_type[$key_selection]})$" | while read img; do CheckDateSort "$img" 2&> /dev/null ; done

echo "All done! You can view your files in $file_folder Thanks"
