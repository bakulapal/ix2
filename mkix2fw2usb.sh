ifw=/home/~/ix4-200d-ix4-200d-2.1.50.30227.tgz
ofw=${ifw%.tgz}-decrypted.tar.gz
ix4=${ifw%.tgz}-files
usb=/mnt/test

mkdir -p $ix4/images
mkdir -p $ix4/update
mkdir -p $ix4/apps

openssl enc -d -aes-128-cbc -md md5 -in $ifw -k "EMCNTGSOHO" -out $ofw
tar xzvf $ofw -C $ix4/update/

imgs=$(find $ix4/update/)
for img in ${imgs} ; do
	if [ -f $img.md5 ] ; then
	  mv $img $ix4/images/
		mv $img.md5 $ix4/images/
	fi
done

mount -o loop,ro $ix4/images/apps $ix4/apps
cp -p $ix4/apps/usr/local/cfg/config.gz $ix4/images/
umount $ix4/apps
gunzip $ix4/images/config.gz

img=$ix4/images/config
md5=$(md5sum $img)
md5=${md5% *}
md5=${md5% }
echo "$md5" > $img.md5

cd $ix4/images/
tar czvf ../ix4-boot.tgz *
			
# ix2-200d_images doesn't work
# https://www.technopat.net/sosyal/konu/upgrading-iomega-ix2-200-to-cloud-edition.2651/
#mkdir -p $usb/emctools/ix4-200_images/
#cp $ix4/ix4-boot.tgz $usb/emctools/ix2-200_images/
