FasdUAS 1.101.10   ��   ��    k             l      ��  ��    � � 
This script was modified from one originally written by Brent Hardinge
(http://brenthardinge.net/blog/applescript-enable-web-sharing-quicksilver)
     � 	 	(   
 T h i s   s c r i p t   w a s   m o d i f i e d   f r o m   o n e   o r i g i n a l l y   w r i t t e n   b y   B r e n t   H a r d i n g e 
 ( h t t p : / / b r e n t h a r d i n g e . n e t / b l o g / a p p l e s c r i p t - e n a b l e - w e b - s h a r i n g - q u i c k s i l v e r ) 
   
  
 l     ��������  ��  ��        l     ��  ��    > 8 DETERMINE WHETHER SYSTEM PREFERENCES IS ALREADY RUNNING     �   p   D E T E R M I N E   W H E T H E R   S Y S T E M   P R E F E R E N C E S   I S   A L R E A D Y   R U N N I N G      l     ��  ��    1 + IF IT IS, STORE THE ID OF THE CURRENT PANE     �   V   I F   I T   I S ,   S T O R E   T H E   I D   O F   T H E   C U R R E N T   P A N E      l    * ����  O     *    k    )       r    	    1    ��
�� 
prun  o      ���� 0 already_running      ��   Z   
 ) ! "���� ! =  
  # $ # o   
 ���� 0 already_running   $ m    ��
�� boovtrue " Q    % % & ' % r     ( ) ( l    *���� * n     + , + 1    ��
�� 
ID   , l    -���� - 1    ��
�� 
xpcp��  ��  ��  ��   ) l      .���� . o      ���� 0 pane_id pane_ID��  ��   & R      ������
�� .ascrerr ****      � ****��  ��   ' r   " % / 0 / m   " # 1 1 � 2 2   0 l      3���� 3 o      ���� 0 pane_id pane_ID��  ��  ��  ��  ��    m      4 4�                                                                                  sprf  alis    |  Macintosh HD               ���H+     qSystem Preferences.app                                          6-ǅc        ����  	                Applications    ���      ǅc       q  0Macintosh HD:Applications:System Preferences.app  .  S y s t e m   P r e f e r e n c e s . a p p    M a c i n t o s h   H D  #Applications/System Preferences.app   / ��  ��  ��     5 6 5 l     ��������  ��  ��   6  7 8 7 l     �� 9 :��   9 8 2 MAKE SURE SUPPORT FOR ASSISTIVE DEVICES IS ACTIVE    : � ; ; d   M A K E   S U R E   S U P P O R T   F O R   A S S I S T I V E   D E V I C E S   I S   A C T I V E 8  < = < l  + � >���� > O   + � ? @ ? Z   / � A B���� A =  / 4 C D C 1   / 2��
�� 
uien D m   2 3��
�� boovfals B k   7 ~ E E  F G F O   7 a H I H k   ; ` J J  K L K I  ; @������
�� .miscactvnull��� ��� null��  ��   L  M N M r   A J O P O 5   A F�� Q��
�� 
xppb Q m   C D R R � S S H c o m . a p p l e . p r e f e r e n c e . u n i v e r s a l a c c e s s
�� kfrmID   P 1   F I��
�� 
xpcp N  T�� T I  K `�� U V
�� .sysodlogaskr        TEXT U b   K X W X W b   K T Y Z Y b   K P [ \ [ m   K L ] ] � ^ ^ x T h i s   s c r i p t   r e q u i r e s   a c c e s s   f o r   a s s i s t i v e   e v i c e s   b e   e n a b l e d . \ o   L O��
�� 
ret  Z o   P S��
�� 
ret  X m   T W _ _ � ` ` � T o   c o n t i n u e ,   c l i c k   t h e   O K   b u t t o n   a n d   e n t e r   a n   a d m i n i s t r a t i v e   p a s s w o r d   i n   t h e   f o r t h c o m i n g   s e c u r i t y   d i a l o g . V �� a��
�� 
disp a m   [ \���� ��  ��   I m   7 8 b b�                                                                                  sprf  alis    |  Macintosh HD               ���H+     qSystem Preferences.app                                          6-ǅc        ����  	                Applications    ���      ǅc       q  0Macintosh HD:Applications:System Preferences.app  .  S y s t e m   P r e f e r e n c e s . a p p    M a c i n t o s h   H D  #Applications/System Preferences.app   / ��   G  c d c r   b g e f e m   b c��
�� boovtrue f 1   c f��
�� 
uien d  g h g Z  h x i j���� i =  h m k l k 1   h k��
�� 
uien l m   k l��
�� boovfals j L   p t m m m   p s n n � o o  u s e r   c a n c e l l e d��  ��   h  p�� p I  y ~�� q��
�� .sysodelanull��� ��� nmbr q m   y z���� ��  ��  ��  ��   @ m   + , r r�                                                                                  sevs  alis    �  Macintosh HD               ���H+     jSystem Events.app                                               5��K$b        ����  	                CoreServices    ���      �K$b       j   &   %  :Macintosh HD:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��   =  s t s l     ��������  ��  ��   t  u v u l     �� w x��   w / )activate application "System Preferences"    x � y y R a c t i v a t e   a p p l i c a t i o n   " S y s t e m   P r e f e r e n c e s " v  z { z l  � � |���� | O   � � } ~ } k   � �    � � � I  � �������
�� .miscactvnull��� ��� null��  ��   �  ��� � I  � ��� ���
�� .miscmvisxppa       xppa � 5   � ��� ���
�� 
xppb � m   � � � � � � � : c o m . a p p l e . p r e f e r e n c e s . s h a r i n g
�� kfrmID  ��  ��   ~ m   � � � ��                                                                                  sprf  alis    |  Macintosh HD               ���H+     qSystem Preferences.app                                          6-ǅc        ����  	                Applications    ���      ǅc       q  0Macintosh HD:Applications:System Preferences.app  .  S y s t e m   P r e f e r e n c e s . a p p    M a c i n t o s h   H D  #Applications/System Preferences.app   / ��  ��  ��   {  � � � l     ��������  ��  ��   �  � � � l  � � ����� � O   � � � � � O   � � � � � k   � � � �  � � � l   � ��� � ���   � � �		set allRows to every row of table 1 of scroll area 1 of group 1 of window "Sharing"				repeat with thisRow in allRows			display dialog "" & value of thisRow		end repeat
		    � � � �d  	 	 s e t   a l l R o w s   t o   e v e r y   r o w   o f   t a b l e   1   o f   s c r o l l   a r e a   1   o f   g r o u p   1   o f   w i n d o w   " S h a r i n g "  	 	  	 	 r e p e a t   w i t h   t h i s R o w   i n   a l l R o w s  	 	 	 d i s p l a y   d i a l o g   " "   &   v a l u e   o f   t h i s R o w  	 	 e n d   r e p e a t 
 	 	 �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � ] Wclick checkbox "Web Sharing" of table 1 of scroll area 1 of group 1 of window "Sharing"    � � � � � c l i c k   c h e c k b o x   " W e b   S h a r i n g "   o f   t a b l e   1   o f   s c r o l l   a r e a   1   o f   g r o u p   1   o f   w i n d o w   " S h a r i n g " �  � � � I  � �������
�� .miscactvnull��� ��� null��  ��   �  � � � I  � ��� � �
�� .sysodlogaskr        TEXT � b   � � � � � b   � � � � � b   � � � � � m   � � � � � � � � P l e a s e   u s e   t h e   s y s t e m   p r e f e r e n c e s   a p p l i c a t i o n   t o   e n a b l e   t h e   W e b   S h a r i n g   s e r v i c e � o   � ���
�� 
ret  � o   � ���
�� 
ret  � m   � � � � � � � � D o   n o t   c l o s e   t h i s   m e s s a g e   u n t i l   y o u   a r e   s u r e   t h e   W e b   S h a r i n g   c h e c k b o x   i s   t i c k e d � �� ���
�� 
btns � J   � � � �  ��� � m   � � � � � � � 8 I   h a v e   t u r n e d   o n   W e b   S h a r i n g��  ��   �  ��� � l  � ���������  ��  ��  ��   � 4   � ��� �
�� 
prcs � m   � � � � � � � $ S y s t e m   P r e f e r e n c e s � m   � � � ��                                                                                  sevs  alis    �  Macintosh HD               ���H+     jSystem Events.app                                               5��K$b        ����  	                CoreServices    ���      �K$b       j   &   %  :Macintosh HD:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��   �  � � � l     ��������  ��  ��   �  ��� � l  � � ����� � P   � � ��� � � O  � � � � � I  � �������
�� .aevtquitnull��� ��� null��  ��   � m   � � � ��                                                                                  sprf  alis    |  Macintosh HD               ���H+     qSystem Preferences.app                                          6-ǅc        ����  	                Applications    ���      ǅc       q  0Macintosh HD:Applications:System Preferences.app  .  S y s t e m   P r e f e r e n c e s . a p p    M a c i n t o s h   H D  #Applications/System Preferences.app   / ��  ��   � ����
�� consrmte��  ��  ��  ��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �   � �  < � �  z � �  � � �  �����  ��  ��   �   �   4�������������� 1 r��~�} R�| ]�{ _�z�y n�x ��w�v � � ��u � ��t
�� 
prun�� 0 already_running  
�� 
xpcp
�� 
ID  �� 0 pane_id pane_ID��  ��  
� 
uien
�~ .miscactvnull��� ��� null
�} 
xppb
�| kfrmID  
�{ 
ret 
�z 
disp
�y .sysodlogaskr        TEXT
�x .sysodelanull��� ��� nmbr
�w .miscmvisxppa       xppa
�v 
prcs
�u 
btns
�t .aevtquitnull��� ��� null�� �� '*�,E�O�e   *�,�,E�W 
X  �E�Y hUO� U*�,f  L� '*j O*���0*�,FO�_ %_ %a %a kl UOe*�,FO*�,f  	a Y hOkj Y hUO� *j O*�a �0j UO� 1*a a / %*j Oa _ %_ %a %a a kvl OPUUOga  � *j UV ascr  ��ޭ