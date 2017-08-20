ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.11.4
docker tag hyperledger/composer-playground:0.11.4 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�,ccQ! ���0����ڎl�ı�jߌ�(�7
}h٪��mn��lh�Uڻ���.����;��C�L�{pw�K2՞�Fi��	-6�Њ��,EPM�rl�J B`{��av���I���e�=�;#�T�pX�H�T���ew��~ ǿ ���%���2t*�ԡe�Tһ��h-�a�
�c��2�j#�`� Pr:�ᑸ�v�&[�T7���dH�g��l9!�5����.�e����t��x$<{łM4����s�P{�pTA�afr�	-�(��T�	Rµ4LL�2��H�/�r�� �i7�=S�j*��-JGFEjum�4�۳�\c��6[��b(򜹼���8&�_���a�~~�� �)3�ݫrL��([�W�N��6���K�,�Z`�ŲuD��3�ܫI�0�J�v���=��Q�T�U�����#���7�E]�ҡ30�.�J��t�p����HMj�3���:�>��x�	�!��+F������M�?�������ϳ���9����s�߁��4��@���}� �/�<�,���g�1^���8�s�o��HC�#��P��Z
��@i�?M��:���+�g�R����1�h���A���i���{�,�im����ǲ����?���:`#�_6̑SV�h;>��A� ��F�����(�!��_��n��� �h�����@�X��$�(L�	^�oj&�@����1 Y��y0���&q~��a�mWj���>���`��d���ڗL�c��$ɮ�1�)�����
�m�#1s�8/��h�׼�m�I�P�JGF�Fo3IW��]�����Q�h۪�c���^��w�t�U�fH����'�t��L
�?���Ep�0z\��l;�����h8m�Ij�}�zYl�{��,4�~Nb*gT�o�u�Q�_*ܲ�5-M���\`�q���8��3(�Ck������3��<�ru�NGv@W�4��-�3�%B`������65.d;���%���ٽ�/����i�Я/)��ak�E�w{����׸J)"�t@��p�2jv��﹟A1lDw5����f���ƹ���`�܍��q'G�/Ӭ��Bj�v��(f�hG�|%��l�DU�G�C!cvxM�����-&�+w�*�8@�WA-øӞ���11/t��Hd��GR�o�%��ʂ8�� C׆d@��ss�'1�9�\�;ڱ���~uQTݑ�:���i��C���á+�=�P���5�8`�Q�0�e~4����^��2ؐ�G��?�4n�~I�u��x��
���6N��5��s�3vFO7��k ���__#N�<F���lB��C[V���������3҃�~0���Af �Y���ϗs��z.�����\|Z�ٍ�w=��I�k��g�y��A��6m�as�24���n֒���Z�id�֐J��{wP'Tu?W9��ʹ���ߐn�~1���oٕ������mL1�C���͈�r.uV�ʕ\������l���	����m����t������#��d�=?@���o�Ո���'��x�2Ko�*��g�\A*ժ7S=�6�vV /l�&�i����D�=V����B�m��J|x��De!��ށ�s��;xnA��oI�qy#����Lq�n�-��=������e�,���N �Ê����U�﬋��l�P�I.���El��W�������w��`e��c������_6���ɖ��E�e�i�/.D7�xx������{��=��hB4�B�[����1��ʾ�:��9�?e/ݿ���?�,�n�?����p�p�|�H�����N�7�X~���h�����
�������+�]���=�e; Z�a�LK���h�'�M;L�x�o����� B�V:�C�쑺g�Jb�α��{ G!���A�<c!2��O7z_�Q����a�N�)2jZ��n��AYGY�/��:x��������d�������B��Y-���Q�1Zȯʎ�P�b�斻>q�f�y��{X�B�gf�?���X|��9F��~��#{��$ qN�vD{#=L\:x������؉���f�̨nj�B�cz��}����������?��.���Z<��?�"�]�1�n\����_��tA
��+�� ��a���e6�x�̏�'��q�y+���X�.ay���g�E���_`ٍ�����[�?�+"��@ �o` �U���z]d[���"	�";য়�Tʀ�W%������;�K\F'pz�<�լ�W�L^¡��u�	�5B��o|(����6n���p���y�q�T��n�;�Ҍᱬ:U�;1eƇ�T�ota0�E�uE�1�ז1��#۠��Ots�q7!#ߊt~A������e�X`��|L������F��|�d�|�͜{�|n�ƣ&��
�m������.�;�]0Q`έ^�hA*$�r�\O���3�'�d^J��c� P}���,��Đ���),є��p��(ѐ���T�,�JR�LL��R�"֪��T�RUBn�^@=I�r�Ɜ�HG���\ݗ������K�l��=�Ku)������Lù����Ãܙ����Q<)s���a�+��W�T����LL��R>�z�}WgS]��B�,Kս����U��٨"lMջ�	�`�1�R���Ah�5��t�	�s�x�����พyS�;/�S��*����-���i���6�������؍�Ǐ|$w
��v�J�P-�&�ȩ}@�`��6�st�A�t����06�^b�O�C��������bѻ�o/�+�[���䟽WВ����;��l�[,;���n���a����Fv������߻�������ų��J_�o		Q'z���-�#��a/�}���jl�N����������]#p[�ʧ��|
XV���R���?���y���-�����	��^�Qx�o�ZT@�WCW��_��Q�j���i6&��i�����\
�H�g�����������!Hn���c"����m��/!�hY��ϡ����������s��-p_�����"�Xs����j�4��;�� �M��8��R�b��5xc��b�v�+/��0fa���ܷ`>z����b���ue����x0�"�U����L�-2�ٔ�Q�"s�H�
��!��]B+>qs��6�g|H4�o���8}n���������C����8~�m��|Xy��������Ţ6����'���/k���Ψ�|����������G��S����h�Qx�K�Va���j�xe'���	���2�Y���D#��O�ۈ�\cG���+����+�Jo��'�45�/��z��'��������2t۰��m��ֿP[�E�:���j�r���7_MTDK���fo�e럿��-j��|���xl�b��?o=E��4N�ye�o���	?�5,G䧞�au�'�Jm�����F���8�����ic���f�������,���j��w�e��Qq�ɏ��B�U���Q.�Q���%+�3�J�~�m���q9��q��eyYn00k�%�evZ;	�R�Ǝ��(��Bl�)3
bEfw�r���e9!�CP긶����m�5 w'�!)esE����\&��I}�r�T�<��T[�b;W�nI�_��dvh�����Վ��I��8�]�3�(�R� v�"[���B�^/\H�b9�.�QU�T��id�^#�ƕ���̹X��j����d����2�	�]�p;٪���0�R61<���ӷ�N�m�>�����O���S�J\��^���b�;J�PU��W��R5��s�ƌ������F����N�����4xS�]J�8ܻT�pp�el������*�G^�/
��z�˸9�txr,��o��K�UH2C���ˎ|,�h,�BE�`6�(�-�+���)�d!������ؖ����{ �LNLfݝ�����^T�����ǋoՓ��s����8��o��z�{\�k�Z�D>2r���B!~?5�b%����r씗�����ZM�"��Q�L�ddp��x��x��˅��ڑ�sQ,�lܫfnp�-��\�g��n<�K&��V9��~5{Hrr�d1�L��ro�}��nA4�=C3���X�j��Q���b������Q=���|����~�*��	����D?Ռ�s�p3z�7æ�1$S�r�B"�V��o��C�Q�)>�7�����^',/�sĀ���
G_��Ϋ�cŵ�?Y��2�w7��`X6�Ğ��#�3#�o�sޢ��(�q������>u�7���_���N�����9���I��\-�@:!�O�B.���d�5:�e2���������C�$�n#��:-�u�¾��챦��L*��#�s;��J�b���Z�lj�ˌ������f�j��S��wkã�02j�}.��S�c�fn��ANV�H�����*{0Y���Sj���v�S�������Ϯ��f�_|���m|�o����ss�~s�w-\�k�|.\�3݁48���)�h�
I�GJ��-Jr|`I�tM�f�.��n�fᛶ)��O)��9��T���[��)':�!u�=8�w/����������I�z����b{o/��OS��G��w����8�����Cy�k �,�O����M��Z�H��"ѓ�d��2�@�4P�i6(C��0��b�߆����!ϗ�R��F-���C�6��E ���M�HÖ��$b�h�.YW/�C�=Y����?j������ =����V���x��C�(��n� �FOV�]��"��6����P!�X���xAjƀ� aU�A���D!et#E������y��y�ߥ�x|m�C�������6���K��������f�G���� [G�t�KW㗄�.74��ͅ�T�H��pd"gCõ����ڵ_�(��㮍�����ĸr��$����o_^V��h��2yc��=�'��ݶ���g{<6�Q����q��q�ݶWO
W�E�ZXĉN��.H��Ю@	� G��TU���|��7q�yv���U���T���ЎG���0�(>`)�;��pp��f��`D��,P�(�˚h�	ys����lSCU���m��U貫oohI>�+�SN/��bk?���H>'M02��~Q��d�̌�36W�� �\䠜l��<t��/A�<M�Ǜ��?�г2l� ݓ�>wzG[g|�&�+?{��������/g$?�w%�nb	m~��C�΀>��M�!�j��m���T!���ɉb��@�)���ކv��n�~�0`�6t:E_�{0�̯Ӕ`�C�h
Q'�Ԑ��\�/
�,��[Ʒ�	�l��&��/�ϸxx��v���=�n@(�Cc���o��6�#����<����E-�c �j�j[�srE���ӑ���]ۘB�X�%��sS �!���c�����pt ��|$+s�1>"���m���S���Td��ɴk9���<������
��پm�[c��.N�)4*]}jB-���k�BJ��w��&ݹ��Tu�����:l�%e�-:d*(�.*��|~��]C�5����#��8��C��FG���Ʉ��Rhݪ�2����Wu����&��NM�-_�]�k#�Vt��I�Bodk�)xcsO5����k&ѷ����zh�@ү;���?�E��d�����W�!�v����>�V����?����s���������}b�_=|����!E�6E�&E,�_�y���w����~���gRh�g_�c�DF�JJ���D,���R/��e"�x����� ))���xFN�	������>��_O����O����٣�;������;}e�~+B|?��H�? �^!k���}���@���=����{w�������y�����V��1�j0�=�X�-J�~:�ܷ�b��$̳�Ͱ������Y�Z����D +�+_E V��:��Bm;���
�ူ�؎rSb;!���ȼ����Y{.���Y����V��� ̳K����"��B]�9�i<g��vk>�3i���z����Y��)6!��Gž4,����L�윍	��9�ߝ����v���|sڎf,�n�yӰ7/����7X�&5hW���}~yT\0C�t���&�IX�x��G��*��&;�M]��\�Xk����/s��A��3%_o&!a��=!�YT�z�J�
a��}���Ơ�"��@���C?h��1��7m�ϖ���jq�WkjX�y���B��"}·D����F<9��'Ƣ�z��y|���!�:ͫ���,�7�,�8U��y&�'��Z�����x֔�l{yT��Y>�w��$��M�N�Giz6��ben&G�X9����f#�Z���.{�{�6�~I�}I�|I�{I�zI�yI�xI�wI�vI�uI�tIl�\^�̻ě����&��_�(��}��p���g��%�,�;��-.������Y���В��%�|�]\��B�֮�@��v�'m`�=ܼ�
�s?��N��e59E��Tq�3��~�*�,-�i����B��x#�*D�$GͨpR��s"���d<��N���L�dBE��m�^�������y���to?Kg�@d�\y�<�DM=^� �liSݔ�'�X�vn_�~Jta�T(b��2I��j®�L��s�vK�h�D�*��� ��'�=c�raU�|��XK6;�ʤ[%�H��A�����!w����{��"��[�����G���[��7v^�}��rÿ`o7�s���e7��o��x�u6�e�<����u�OC��|#����}v���+����{���
����z#��_�˲�~��'�~�Q��$�B����?r��?x���<��?�֔��Д�`��y+=����T�֢̥�'I�׽����}~�����F7��k���rv�<�\�m�f:O�r������pLW��T�t�֦>��g�+��#�(-���:�Y9�alɬ�4�Q�1K*WHM��dq�W��Y��$����H��re�va_F����M�١�t�q޶�8m�{���0WT5~\<6��M��tű2i��[m�"�;mFms�;���`<��42�����cAf՚�d qˡ��aU����~�x?��@�8�h�`۹��o�|{����5G��4�p�Fk'�bP=�K��o��TDTNR��IFj$!�k�pд�BTA���Yc{T�ό�~\W�;�Q�ş��./��d�����⁽_�Vi�(P��@��.�y�9�	�R�K�*�:�ח����������/mȹ%}������#�k?aE.&��E��[�����0�w�X?�>>�J����wO�	��m�z0����>��o��rY�-�d��Z��5S�^-U���)N���65�r)�?hi��Xi-s6N0��bu���������W�QZ˞2�l���e�3��p�h�	�9'P�
4m9�r�dk6o�jk8�Z��y5W��T�7�O���GpN'tU"�4��c5�/
\u2���>-��Q�$]U�c�XhĦ<抍ԬH0�o�yG�
�z]�
��b<�/�{�lA�����52}jP�P����%�tqY{�B1�_]�e9��ʑ�ٰ6�h��@e���1�BTbK�u$���]G2�y�N�v	F��ؙ�]��	����t& N�<gRG��P����z��(�b��q�(;�7�z���đ�r�	���\֤{�hz֩5x5�-��1t:�h��	�*Q��l��|L_��3�H/��Qn�Pϣlq(�f�-������hi���#��g�B-��D�]vB@\(���w(L�_�i�R��DM�O��|ܢ;"}r��W�ِ��фB�}8�d�f0vcގL�P�&9�j�H��q}!v:�V�Qa�
w�2�ail�>}c��@\�n�`���E�7������c���w`u��s�Q��Л�Qӣ��e���Ӛh΋�ЎO�+�/�_edNMq1VB��"�4��I����e4��zz{�x��/��>��K�o��JZ�6z�x�y�qPD�ƓŇ�M�4��1��1�5�9��2~��>!�/ ���TZWH��ОpM��֧�/b�,������rN'X4;�?���<��9�,O�T�P"�K|��o��^��E^�tn��Tv�ל�����s��Od�o�şk��E���?ģѯ��������+��%p��wӤ��)�j���ϝ\C�y�ܙ�!)���͗�>$F��a���d�
��L�P��Ή��hW�3tT��n�ww�!A��&�i���;��Wצ�����w���'���0�*At�z^���R��4�u=�ŗ�Y^S�_���Y:��pK%�����"���[�V��uÁ����b	� �\ �?���a����(�� �s��~��L]��3A���`����1�7���q���m#�����.�51���$y�4��T�ɑ}jv��4���ԑ�4�<��_P�Wh5��2`	� �t��d�J|L��'X]T�`�2���Kt�lC���§��=P1�w������y����rn<�L��sER@��j���Y���6��49ׅ���w���m��������\�46���C8j���8X!�"tb��Ɣ��$�2(0�N�QW�����s�$��T��ٝȾܺ#�;����M�o"lo.z������}c��lX؏���z���aS�����"��+Nx��0M|ֳ
�hc|l�t��h>��Ŧb�4�Zc�"ZW�����p�Fb���p,��Fʡ̭5n���"rؼ�p�BR�3����pY���Wۀ��5.�oD�7�c����$��G&p��l]`�Һ[�&�������~��)���w���p�I�r��8�
"$���x�/0���Pπ�;�1`N���0�wo z��N�"��S�?�^�{٬۫.^� ݵ��`�P����dTO�`()=�Cm#
H	��|�.�d�\�VIP�5�&�nn������F)�k��W�1�5����bf�`���m@�ce2�MA��@��qs��B�K�%(�)���XfaA!;���/�+!*t½a;x�	D�^�h@�͒WU\U�`e��"`�n��4)0��Uq�6�lTo�?x��#i/|t���cƽRa�n��*T� �5&k�v����7v%�%�\�!=9��L�r�ºf�q�iH�y�8� V@Yݣ�� �rE��䫇�vh�_�M��6�4M��t��L$]Y���<74�h���N��%p���N(-�D�w1�n�-n�0R,ۘ\��)�t��~�ոp���g��'�f������ް�_�����]���2����HES����Qg���翾��q��F?%4���l�sñ����Ûܕ��3��F�����i�>EWc<+V7���;(�dlp�c����i�bKm���ʅ^����
_M[��?E'���k
:��/V�FeЋ%�R )��D��)�D/��u�J��S=
����g��ԓz�$���
�&��9p,�{���{����^���>��K~�Y'�%��T|iȍ[��C|�9<���XR %@��H<I�@��J� @2�(�H:�Vb@�� %��(�B�$P�`ȧ�s�!�;�ɧ�X3�����/<y���M[�v�{�٩�Qn�(���&[�o!�Fe��>x��V�,W��:ϕ�:]:-U�%�+=�i�^N�7D�L�l�k4�Ep|�����'*�3���v����/ٲvE��tIhTy�Y`��:jt�Յ*ͱ�څWV����TF�3acl�U����I7�jV*��t��ֵ�;�b���I�3s�2���}q�z�Z#{��;𖁈p��M	�ҷ/�l�W,�\>�/�z��V��y��?�r\}c����͗�vE�(�1��:�pʕ�j�/�Ϧ#m~��V��L����� �9Q�pH^������q�եͺ����Z�4�l����eNlU�Gl�3O�N��v�]�gM�"Lu�Wi�pQiP�}mYu��aކH���E��ܳ,��e���V��˸mr�/{W֜��l��+�;u��[�U}� !��҄�'	����`H����N��!�"�mi�ս�W?]��a��$���	�b��e'���W��6���?O�<����t9v�;�����M���S��_��]ӳ��7��G��:��s�V&�y��W����x��~=��m��w��ą��������~�7w���Y����.��G���i�?����?*/�K�����������^7��b�M
�?���H����\����g�r����$i���G�߾�7���gh���G,��9�����o���?������� @��o���G�����������@���?|"P�e��@��?9��8����G��������3E?ҿ,�wg��?$@���H��Q�(&Er$�u��"�`�pa��$�T�")����&X1�(�X��M?�����!�gx�V���/$�F�=����?�Qi0Yf��j�w�Q�uG�r��2�Hʻ��q�������ϸR6�~�уt!���p�-]&����#�α���dJG~���4<�3��u���6�u��yM�1���d������ٟ�����a���q�x�()�{����%�O
��G��&����@��?(,��z ����7�?N��Q�`���i}	>5�����J�����G��ډ{)�,z ������<�?
���W��B�(:������4���� ��9�0��.�|��ԝ�O��@�_�C�_ ������n�?��#�����C��Q����?
��ۗ�?^|����Ak,�n)�ץZ̥S7Wn�?O�����z���^Z?���~^^#̚����K�'���<�>�e���ϧ�Obf�?T4q6KKƩQ?*������T��,�n��A�2kl��z���L���v�S+�b|�T��Cm�}\��������������Ϫ��7B�'5:�w]y�o�W������1X���l4^o��}����<w��2���̈�$ιSi�t�m)Y�j����h�ը������YG�.Ey��n�Ͷcwu��b/u�[� �����wm�@1���s�?,���^�.Q��E�������H �O���O��Tl�G�Ѡ�P ��N(�/
�n���?���?��X���7A����!������b���_������a&�x�Ѱ�6﮺��%����q�cX�{���T�/���5w-��a@�`�Gun&� �7�����U�.�d�᭥|!4J9�4#�)�$i�rS��#�5T������[���װ��>��eSίq�������7B���ڹ���;�'���_{��a�6�r��еM4I���O/cm/��9���(V�j�Uґ'r�{`�|w�ʬ���󊩞�+9�H#CR�'�zfoa��@��X�?���@�� �o�l��!�/ �n���3����#N��JG�$OE���ȑ�$1��a(�!�3>/�4�$�!�HL@�$��u������!�G�������^cz�(�v�R�x"]��~{��,��}^�V��&	����-���ܳ��>�ǻ�Iz�=������p������m���j�X2j�n-I}�in�M���*
��K��n�9~T������?�C��6�S�B����_q������0`�����9,�b|B��������,[��zi��'B�;�3��Ļ��V�Sϛ�����S��7���Ԥ]��uL�����U�9���(w&��<��%d'Ik��ܞS:�s�6ڕ�N��y���.���<�������oA�`�����xm��P��_����������?������,X�?A��gI�^�������;a��*��n1���'�ax��M��?�ѓ�e�I����g q}�3 �o��� g�V{�p*�U��e��3 d{?Z��!�K�l�4N�%=#g�vD�K��Ҩ�F���:�֩���.%V��Y�Jg��@۪�\�����N%+[.���D��w�]?y�
����U/3 l���r��J�W���$��+�h_����[�}O��:e�z��Db��5h1N+�X���j�Ё`�cS)���2�F~�i�Po��4ʦn���k���n])�Ѯ~
��pب)��p��%��G�M�]��VS�(�X*�Ϊ�=�/ϳ�ʬ��lc��<9(U�g�zc3��n4�A�Q��ǂ�C����C*<����������x�?P ���;�?���H�<��*��E�N !�G�������b��(��/H�%���A��H
�Qt̆�/�����ȋ1��e���t$J1+Ĕ��14v~p�����r�� ����Z�nv2�.7\��.Mp����d��Y9;�6=��[&��������h�`�����ة�ZU��mj⾔w��QZ��"�Z$���֢���s��G|gW3]�����*�^��m�̢����?�ޙ��$�x��X<�-?��C���i��� ���������-&��#����������A�" �����8���_�����������P�Z�m�Z˞U:Fe�z\��J������TH��&�O��:m����~_^#�S�}9�&~Z���}����>'�?�V<�����Nl���N�쭚{�L�����xmL�;ݺR[6g��0︣�ߐ?r&�<�[�h9���Q��{�~�&yc��*MSf���,W{�z��m-�^Qέ,���C��m�9���z�ġ�Z[R��愮s5��w�Uىl�j�*�6l�P�dt�1+�'��K���+	���β��=i�F��H���V��*+}��FnJ��!=�����Qe%aYnGƺ,p�g�����q���[�����e�ׂ����7��ߩ��i��C����o����o8���q�/�����n�����q@���!����������( ��������[�����o�
|���K/����	��������	p��$o��P�������?����B������p������G��!
�?����ݙ��H���9j���_�`��	������.�x���M��?��!��ϭ������0�h) 8�����@� �� �8��W��s�����X�?�����!P������H ��� ���Pl�G���#`���I��E��ϭ�����{�{����H��C�?r��C�q�������?:�����G��C��,>��jC�_  �����g��0�p��:����>�� 2�8�x��J,����b��'B�_
(��%�e9������8�?�S��o��v��#��i�ç��Z;G���"P�J��%7`�	Iy��4V��4�<���P�ت��������Ӱ��nܑ-U�;۽�ڮ�Y���T�U�t�u�*qB���{�;ܑ��c�����$Q����Z��-:��P.k����j]2^Ċ9^������K}�1�?�����l��������C�Oa���>��sX�������!�+�3�k���JY��WJ�ƚ�J�Q�֦��ԩ��e�j���֗�c�׍g��s�̶֩J]z��d����`L�n�I|�cSv�;%�v���p}�ʛ����-�^��d�N�,����Y��x��7��!������O���� 꿠��8@��A��A��_��ЀE �w~����A�}<^����_���S����-�tv:݋Jb��r�WI��{�vi�)��U�u0����x�1릻���a���g҆g��p$d�b�H6��QK���4�T���y����F�IS~*�N��1�e'̈́_�'����VjVW9q����㕾x�]�N����nE�M�|/l�D�(���<�M��f��˵r��c���)Z R�l[���"1D��-�i��6��f�P6u[5j�!p7�f��43##����84�����R�9��D1:����R�_T���Y)�dz��k��6̬<Z�9ac����x'���Q�}�<��W��Ҥ@����I���_$���>�������O����������o$������%^����:��$E�� �O����/��h����<=�*������<�w��(�R��ꪪ����~a�����3)IiFc�1oN��@���Mv��?T��a�*�>dܴ�z:+�o��aV�kʏx�܏���5�g�z�x�g�S���$O���%uy�\^\K�omK�]��$�c��P�f]ME�/uN}��n/l��R�ϝ�N��Ƽ�Х�^%gk]M�Q����	��J�5��e�ZeNɚ���]w�W��I��'�xoW���r��V����7�t�;?/k�$C������q}s���]+������Ğ(�"��awÔ{�<�~Lu�en'�}�fs�iLBmK�|֬u�e��&k�.Ozܜ8�B%l���Î�^_���` ��~A�s����SJ�D��e_ɝÐ��� 7���'���;?v=/�KNK����7��,�wS�翈�F�	G<���0)���R��e����$͏F��2��g�������c2�"���(���������!�����d$׼lg�'�< 	݋��^����]\?|�3F=������V�|�V��ȕ�Z����⣟�K���?�%�������[��?$@��C�c�X���m��	^��5O����5�gd��M'J[�-]��h����.��_�W������.	6�m��ٗr?�=��K�xE�o`*�S����{J������$sj�r�*5aǫ��ޕ6+�m���
�^ŋ���� �vtu  8�CGG �
"������̛�U����t����"e����{Z)���!��H���CsYs�N��dm�(;.�[8M[�Y��=��8:.H6�����ˑ}e��!�:�w�C����pv�E-��R���&R�펕��>�[{�����m"���Xgf�ֽ���#{�3�\ϺI�ba���Cw=�u�����u7>��&�ڜg���(/^k*����f�'���?���E�Ľ�������J�n��*�U�*A�3~:����05�Rq��V�d���e����d^�U`���������*��o����s�OlЮ/�F[��Ʊ7B�5anl��#9�wu��i^o8/��/[RՂ|�l���[?����7��1�Y��/Q{�����x�մ�Vx,$��������������
����������!��_���S����������������PmuCkon�����0ns��������♝\�}���j��|� ��Y}$T�����N�����l�m�e[�öx�Zי+�[���3W��ҕ+v�ryma,���fߗ���y��pV*��2
��؋���z�\
G��dQ�{�����z��Ǿ1=��:�p��-⁻�����r����Z��K�N�-�w,���Ɨ�����|�e��e�g���X޲��=����%6�kc�����5-^n�Bp�<�xIi�Xu���Ͷ�}S�U{���Jc��������pS�]u�h��`0b֪�ȪԐ�5�pd�aM�;ő0���Z�p��}j[U�?�}�_F�~o�o���Y���
�Q��c�"�?�����H-
���2�g����O����O����V��s8�?��+���~Ș���`(D�������L �o���o�����ޢ������]~Y|�>�'1���A!�����ό��ߤ�C�P �����w�a�7����`�� ��ϟ�	�&���y�?�B������������
�������?���l���L ��� ���B�?���/�d�<�����[���+7�������P�
���?$��� ��������A�e���"@���������� ��9�����C��0��	����������� �?� O�:�����[����;����	������
�C�n��������E!�F��ON�S���Sm��� ��c�"����a���P��i�L�2KJ�k$��Kͬ���ҬT)�`����n�ZMM�P���0�Bc4�>|����"�����!�?���{y��E��0���R���͵%�m���-����Xhp���@�o���5�s��յӈ�#�ءU��7	���	�k�+:`�6o�t�z���n� N�|\&��n\х��$>Y#�X*$v@遪p������%
�{���*3����U�͓��jk��+��x���n����?�懼��h��E@����C���C�����$̻E��������8�j�^�):�0$f�带�4�X�f��}$���|x����d�]v������v��D��g#���=�G89l*U��3�FEGwMs�TTN�V�HZ/w+e�Kb-��C�\��}-���W`�7'���������7B!��+7@��A����远�@�B�?����_���߳��~�ݎ�Z[u`�'�$pC�����8�����%�9�[H�����t ��|�y=��b2˵��i��0�;\D���n��6Yv5oVf�q��gf<-�3�ȹ��k�$�
3�����koԥ_Q��^�ǠG	͕V�vm����K��U�ȶ�.���p,\�&+�,A��z��L!�s\�H��:��G�"9ND_�\���:�X_��^K>���'�������qv���}I��F�T����u�s6n��q^�����q�&����a�:&��Ԥ����.aj�qT�A��|�Q��S���޺�9 �=
�,��/��a7�&������G!���S�� �g������k�?���?���O`7��b(��,�+��E`y7����?w�������O&ȝ�_-�w[<"����s��N���f�"�?�@f������?&�O@�G �G����E!�~g��_&�]��
��������X�!7��a��\P������Š�#|������?�z�B��q�SG`3zi�7��(��=�/�1�\��V �V��~��H?�+�i�����67���v�u������~�'6��̞�i�\�{���#5�GN�e��;]��y��Xo�4m�fyW3�З�� ٰjN�3WT,G��IZ��|k����S��j��u8�vlJe~Rf�H��;V����\n�)+��g��ܯ�e��qZ�f�����Npld�r=�����(��z�H39k[�n|,��M�9ϰɍQ^��T^)$����N2c�g�����sC����"�y��#���������E���0
�)
�����`�?���������0��r�ϻ)�?��+�S�N(��9 ����!�?7|)������W���n�m6�9�T�(kԞ��������q,Y���Awݝ��e
T�����zwb�p
Ȟ�T	�Y�몎��VQ�;l��C�+���E�谭���6v�2�QB��
ww�P_�d�5�� I� �J ��Q� f�+[��l����2{�G��mH�� �3	��-����9`5����܎4+����=�ro��v�F�e͜��N����3
���;뿀�W&�]�}X<�xL@������_���?V���@q������VӤU]�UUcY�4¤0�&5�"L���5��uS�4)��ڨUbI��÷����(��[������\�s�,��CzU�5_���H�y�wT|5��b�U̵ḥZ����|���y�ʺ�B[��{k�� Қ�c۷*��9�
}�:Dyu���9J�y9m��x&�f��I |�a�~4��?�E����3?�����@�� �"����B�?������e�$̻)E����������~3�W�֓]bH]��t�u�a���?G}.v�����C�D�ƣ��~�l���A�o5��G��0�fXe�hb�.OＯ�_1��������ن�ɍ7�9;z$��ע��M���?�������
 �B�A�Wn��/����/�����y����E�U�������������e�>=�=%��j�w�w�����/5 �S�}[ r]�u@ym�{u#��NU�e�a��b�agx��UM_ۢ1�u�D>Ր5Z�W�*�hz8F�[�*���<Sj�����5����u�͊���Oe��<Ne�F�E�q��*7�9���6N�C��E.n�� �
�'��G�qӯV%/kJU�y=b]s[��KSҾ�a1�\�<���*��(�Ѭ3e�;ԧBz.7>�[}ԋ�gƁ�G�&���@i_�yf"�=�[�
1fOkq�#s�V��j!$O�u�ע�M��AhN�֚���_��� ��k��N0�i���q����f������cd��>���+��t�ᕒF�FF��K���ӧ���IuF=�� *�,7����(�ﱣ�/?��u�r\tLO�����1J��/�{�
R�1���m������V_��>���Y��OZ����۪�����H.�e������ec�-]_���u�˖b>�o��}�ӧ$��<�����/������O�i�<�o���9���� �(	G'*m���aT2�`�������&}b\�[�OHhD�w�!}��Z)����#9r��m�R�����J�������T�H^�ʱ���aw<�����﷟J��S��,��2y��y~˯�	~���s� ˄������μ=������)-��������w��>c5is�'�6��2���(E�����x���~k^�/,�vB^����*m�
>��KN�ҧ�:���������/��Q�������� �noK?�z��ߐpc���M��B�����.��\���|���m`������K��ﶥ;1�1�%$�9��͍������=�N/V�:��]R��n�铻x�����@x�������w;�,=wT7�!�Ô�.�~�I�?}Uì��}�}~�/]Y��~zB����   @������� � 