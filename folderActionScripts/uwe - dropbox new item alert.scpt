FasdUAS 1.101.10   ��   ��    k             l      ��  ��    j d
this code is descended from Apple sample code.
The original script was "add - new item alert.scpt"
     � 	 	 � 
 t h i s   c o d e   i s   d e s c e n d e d   f r o m   A p p l e   s a m p l e   c o d e . 
 T h e   o r i g i n a l   s c r i p t   w a s   " a d d   -   n e w   i t e m   a l e r t . s c p t " 
   
  
 l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��    ) # load from config properties script     �   F   l o a d   f r o m   c o n f i g   p r o p e r t i e s   s c r i p t      l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      j     �� �� ,0 configscriptfilename configScriptFilename  m        �   8 u w e   -   c o n f i g   p r o p e r t i e s . s c p t     !   l     ��������  ��  ��   !  " # " l    @ $���� $ Q     @ % & ' % r     ( ) ( c    
 * + * o    ���� ,0 configscriptfilename configScriptFilename + m    	��
�� 
alis ) o      ���� &0 configscriptalias configScriptAlias & R      ������
�� .ascrerr ****      � ****��  ��   ' Q    @ , -�� , k    7 . .  / 0 / O   % 1 2 1 r    $ 3 4 3 n    " 5 6 5 m     "��
�� 
cfol 6 l     7���� 7 I    �� 8��
�� .earsffdralis        afdr 8  f    ��  ��  ��   4 o      ���� 0 
thisfolder 
thisFolder 2 m     9 9�                                                                                  MACS  alis    r  Macintosh HD               ���H+     j
Finder.app                                                       ��ǵ�        ����  	                CoreServices    ���      ǵ�       j   &   %  3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��   0  : ; : r   & 1 < = < b   & / > ? > l  & ) @���� @ c   & ) A B A o   & '���� 0 
thisfolder 
thisFolder B m   ' (��
�� 
TEXT��  ��   ? o   ) .���� ,0 configscriptfilename configScriptFilename = o      ���� &0 configscriptalias configScriptAlias ;  C�� C r   2 7 D E D c   2 5 F G F o   2 3���� &0 configscriptalias configScriptAlias G m   3 4��
�� 
alis E o      ���� &0 configscriptalias configScriptAlias��   - R      ������
�� .ascrerr ****      � ****��  ��  ��  ��  ��   #  H I H l     ��������  ��  ��   I  J K J l  A H L���� L r   A H M N M I  A F�� O��
�� .sysoloadscpt        file O o   A B���� &0 configscriptalias configScriptAlias��   N o      ���� 0 configscript configScript��  ��   K  P Q P l     ��������  ��  ��   Q  R S R l     �� T U��   T 9 3 set the amount of time before dialogs auto-answer.    U � V V f   s e t   t h e   a m o u n t   o f   t i m e   b e f o r e   d i a l o g s   a u t o - a n s w e r . S  W X W l  I N Y���� Y r   I N Z [ Z n   I L \ ] \ o   J L���� 0 dialog_timeout   ] o   I J���� 0 configscript configScript [ o      ���� 0 dialog_timeout  ��  ��   X  ^ _ ^ l     ��������  ��  ��   _  ` a ` l     �� b c��   b    for php processing script    c � d d 4   f o r   p h p   p r o c e s s i n g   s c r i p t a  e f e l  O T g���� g r   O T h i h n   O R j k j o   P R���� 0 php_incoming_folder   k o   O P���� 0 configscript configScript i o      ���� 0 php_incoming_folder  ��  ��   f  l m l l  U Z n���� n r   U Z o p o n   U X q r q o   V X���� 0 php_processing_web_address   r o   U V���� 0 configscript configScript p o      ���� 0 php_processing_web_address  ��  ��   m  s t s l     ��������  ��  ��   t  u v u l     �� w x��   w   question to ask user    x � y y *   q u e s t i o n   t o   a s k   u s e r v  z { z l  [ ` |���� | r   [ ` } ~ } n   [ ^  �  o   \ ^���� 0 alert_question   � o   [ \���� 0 configscript configScript ~ o      ���� 0 alert_question  ��  ��   {  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � J D--------------------------------------------------------------------    � � � � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - �  � � � l     �� � ���   �   begin code    � � � �    b e g i n   c o d e �  � � � l     �� � ���   � J D--------------------------------------------------------------------    � � � � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - �  � � � l     ��������  ��  ��   �  ��� � i     � � � I     �� � �
�� .facofgetnull���     alis � o      ���� 0 this_folder   � �� ���
�� 
flst � o      ���� 0 added_items  ��   � Q     � � ��� � k    � � �  � � � l   ��������  ��  ��   �  � � � O     � � � k     � �  � � � l   �� � ���   �   get the name of the folder    � � � � 4 g e t   t h e   n a m e   o f   t h e   f o l d e r �  � � � r     � � � l   
 ����� � n    
 � � � 1    
��
�� 
pnam � o    ���� 0 this_folder  ��  ��   � l      ����� � o      ���� 0 folder_name  ��  ��   �  � � � l   ��������  ��  ��   �  � � � l   �� � ���   � " show the items in the folder    � � � � 8 s h o w   t h e   i t e m s   i n   t h e   f o l d e r �  � � � l   �� � ���   �  open this_folder    � � � �   o p e n   t h i s _ f o l d e r �  � � � l   �� � ���   �  reveal the added_items    � � � � , r e v e a l   t h e   a d d e d _ i t e m s �  � � � l   ��������  ��  ��   �  � � � l   �� � ���   � ' ! move the items to the php folder    � � � � B   m o v e   t h e   i t e m s   t o   t h e   p h p   f o l d e r �  ��� � I   �� � �
�� .coremoveobj        obj  � o    ���� 0 added_items   � �� ���
�� 
insh � o    ���� 0 php_incoming_folder  ��  ��   � m     � ��                                                                                  MACS  alis    r  Macintosh HD               ���H+     j
Finder.app                                                       ��ǵ�        ����  	                CoreServices    ���      ǵ�       j   &   %  3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��   �  � � � l   ��������  ��  ��   �  � � � l   ����~��  �  �~   �  � � � l   �} � ��}   � A ; find out how many new items have been placed in the folder    � � � � v   f i n d   o u t   h o w   m a n y   n e w   i t e m s   h a v e   b e e n   p l a c e d   i n   t h e   f o l d e r �  � � � r     � � � l    ��|�{ � n     � � � m    �z
�z 
nmbr � n    � � � 2   �y
�y 
cobj � l    ��x�w � o    �v�v 0 added_items  �x  �w  �|  �{   � l      ��u�t � o      �s�s 0 
item_count  �u  �t   �  � � � l   �r � ��r   �  create the alert string    � � � � . c r e a t e   t h e   a l e r t   s t r i n g �  � � � r    ' � � � c    % � � � l   # ��q�p � b    # � � � b    ! � � � m     � � � � � * F o l d e r   A c t i o n s   A l e r t : � o     �o
�o 
ret  � o   ! "�n
�n 
ret �q  �p   � m   # $�m
�m 
utxt � o      �l�l 0 alert_message   �  � � � Z   ( ? � ��k � � ?  ( + � � � l  ( ) ��j�i � o   ( )�h�h 0 
item_count  �j  �i   � m   ) *�g�g  � r   . 7 � � � b   . 5 � � � b   . 3   o   . /�f�f 0 alert_message   l  / 2�e�d c   / 2 l  / 0�c�b o   / 0�a�a 0 
item_count  �c  �b   m   0 1�`
�` 
ctxt�e  �d   � m   3 4 �    n e w   i t e m s   � o      �_�_ 0 alert_message  �k   � r   : ?	 b   : =

 o   : ;�^�^ 0 alert_message   m   ; < �  O n e   n e w   i t e m  	 o      �]�] 0 alert_message   �  r   @ M b   @ K b   @ I b   @ G b   @ E b   @ C o   @ A�\�\ 0 alert_message   m   A B � $ p l a c e d   i n     f o l d e r   m   C D utxt  l  E F�[�Z o   E F�Y�Y 0 folder_name  �[  �Z   m   G H   utxt  m   I J!! �""  . o      �X�X 0 alert_message   #$# r   N W%&% l  N U'�W�V' b   N U()( b   N S*+* b   N Q,-, l  N O.�U�T. o   N O�S�S 0 alert_message  �U  �T  - o   O P�R
�R 
ret + o   Q R�Q
�Q 
ret ) o   S T�P�P 0 alert_question  �W  �V  & l     /�O�N/ o      �M�M 0 alert_message  �O  �N  $ 010 l  X X�L�K�J�L  �K  �J  1 232 l  X X�I45�I  4 0 * determine what the user would like to do    5 �66 T   d e t e r m i n e   w h a t   t h e   u s e r   w o u l d   l i k e   t o   d o  3 787 I  X v�H9:
�H .sysodlogaskr        TEXT9 l  X Y;�G�F; o   X Y�E�E 0 alert_message  �G  �F  : �D<=
�D 
btns< J   \ d>> ?@? m   \ _AA �BB  Y e s@ C�CC m   _ bDD �EE  N o�C  = �BFG
�B 
dfltF m   g h�A�A G �@HI
�@ 
dispH m   k l�?�? I �>J�=
�> 
givuJ o   o p�<�< 0 dialog_timeout  �=  8 KLK r   w �MNM l  w ~O�;�:O n   w ~PQP 1   z ~�9
�9 
bhitQ l  w zR�8�7R 1   w z�6
�6 
rslt�8  �7  �;  �:  N l     S�5�4S o      �3�3 0 user_choice  �5  �4  L T�2T Z   � �UV�1�0U =  � �WXW o   � ��/�/ 0 user_choice  X m   � �YY �ZZ  Y e sV I  � ��.[�-
�. .GURLGURLnull��� ��� TEXT[ o   � ��,�, 0 php_processing_web_address  �-  �1  �0  �2   � R      �+�*�)
�+ .ascrerr ****      � ****�*  �)  ��  ��       �(\ ]^_`a�'bcd�&�%�(  \ �$�#�"�!� ��������$ ,0 configscriptfilename configScriptFilename
�# .facofgetnull���     alis
�" .aevtoappnull  �   � ****�! 0 
thisfolder 
thisFolder�  &0 configscriptalias configScriptAlias� 0 configscript configScript� 0 dialog_timeout  � 0 php_incoming_folder  � 0 php_processing_web_address  � 0 alert_question  �  �  ] � ���ef�
� .facofgetnull���     alis� 0 this_folder  � ���
� 
flst� 0 added_items  �  e 
��������
�	�� 0 this_folder  � 0 added_items  � 0 folder_name  � 0 php_incoming_folder  � 0 
item_count  � 0 alert_message  � 0 alert_question  �
 0 dialog_timeout  �	 0 user_choice  � 0 php_processing_web_address  f  ������ ����  !��AD��������������Y������
� 
pnam
� 
insh
� .coremoveobj        obj 
� 
cobj
� 
nmbr
� 
ret 
� 
utxt
�  
ctxt
�� 
btns
�� 
dflt
�� 
disp
�� 
givu�� 
�� .sysodlogaskr        TEXT
�� 
rslt
�� 
bhit
�� .GURLGURLnull��� ��� TEXT��  ��  � � �� ��,E�O��l UO��-�,E�O��%�%�&E�O�k ���&%�%E�Y ��%E�O��%�%�%�%�%E�O��%�%�%E�O�a a a lva la ka �a  O_ a ,E�O�a   
�j Y hW X  h^ ��g����hi��
�� .aevtoappnull  �   � ****g k     `jj  "kk  Jll  Wmm  enn  loo  z����  ��  ��  h  i �������� 9��������������������
�� 
alis�� &0 configscriptalias configScriptAlias��  ��  
�� .earsffdralis        afdr
�� 
cfol�� 0 
thisfolder 
thisFolder
�� 
TEXT
�� .sysoloadscpt        file�� 0 configscript configScript�� 0 dialog_timeout  �� 0 php_incoming_folder  �� 0 php_processing_web_address  �� 0 alert_question  �� a b   �&E�W 3X   %� )j �,E�UO��&b   %E�O��&E�W X  hO�j 	E�O��,E�O��,E�O��,E�O��,E�_ pp q��rq s��ts u��vu w��xw y��zy {��|{ }��~} ���  9��
�� 
sdsk
�� 
cfol� ��� 
 U s e r s
�� 
cfol~ ���  p p a d
�� 
cfol| ���  D o c u m e n t s
�� 
cfolz ���   u w e T r a n s c r i p t i o n
�� 
cfolx ��� . o s x - w o r k f l o w - a u t o m a t i o n
�� 
cfolv ���  w i t h G i t H u b
�� 
cfolt ��� ( u w e A u d i o S e g m e n t a t i o n
�� 
cfolr ��� & f o l d e r A c t i o n S c r i p t s`�alis    �   Macintosh HD               ���H+   '[uwe - config properties.scpt                                    '.���ƣosasToyS����  	                folderActionScripts     ���      �Ը�      '[ 'W 'Y 'e &�� TA T4  ��  �Macintosh HD:Users:ppad:Documents:uweTranscription:osx-workflow-automation:withGitHub:uweAudioSegmentation:folderActionScripts:uwe - config properties.scpt   :  u w e   -   c o n f i g   p r o p e r t i e s . s c p t    M a c i n t o s h   H D  �Users/ppad/Documents/uweTranscription/osx-workflow-automation/withGitHub/uweAudioSegmentation/folderActionScripts/uwe - config properties.scpt  /    ��  a ��� ���  � k      �� ��� l      ������  � Y S
the properties defined here are used by the "uwe - dropbox new item alert" script
   � ��� � 
 t h e   p r o p e r t i e s   d e f i n e d   h e r e   a r e   u s e d   b y   t h e   " u w e   -   d r o p b o x   n e w   i t e m   a l e r t "   s c r i p t 
� ��� l     ��������  ��  ��  � ��� l     ������  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ������  �   begin configuration   � ��� (   b e g i n   c o n f i g u r a t i o n� ��� l     ������  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ��������  ��  ��  � ��� l     ������  � 9 3 set the amount of time before dialogs auto-answer.   � ��� f   s e t   t h e   a m o u n t   o f   t i m e   b e f o r e   d i a l o g s   a u t o - a n s w e r .� ��� j     ����� 0 dialog_timeout  � m     ���� � ��� l     ��������  ��  ��  � ��� l     ������  �    for php processing script   � ��� 4   f o r   p h p   p r o c e s s i n g   s c r i p t� ��� j    ����� 0 php_incoming_folder  � m    bb ��� B f a t 3 2 : a p a c h e 2 : p r o c e s s i n g : i n c o m i n g� ��� j    ����� 0 php_processing_web_address  � m    cc ��� 8 h t t p : / / 1 2 7 . 0 . 0 . 1 / p r o c e s s i n g /� ��� l     ��������  ��  ��  � ��� l     ������  �   question to ask user   � ��� *   q u e s t i o n   t o   a s k   u s e r� ���� j   	 ����� 0 alert_question  � m   	 
dd ��� � D o   y o u   w a n t   t o   o p e n   a   w e b - b r o w s e r   t o   u s e   t h e   P H P   p r o c e s s i n g   i n t e r f a c e ?��  � �����bcd��  � ���������� 0 dialog_timeout  �� 0 php_incoming_folder  �� 0 php_processing_web_address  �� 0 alert_question  �� �' �&  �%  ascr  ��ޭ