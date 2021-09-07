000100210907                   /*********************************************************************/
000101210907/*                                                                   */
000102210907/*       MIDAS - /COPY Member GLC39                                  */
000103210907/*                                                                   */
000104210907/*       DRI006_002 - MIDAS GL Declare DRI006 Variables              */
000105210907/*                                                                   */
000106210907/*       Last Ament No. DRI006  *CREATE    DATE 01Jun21              */
000107210907/*                                                                   */
000108210907/*********************************************************************/
000109210907/*                                                                   */
000110210907/*       DRI006 - ACCNTAB COB save at monthend                       */
000111210907/*                                                                   */
000112210907/*********************************************************************/
000113210907                                                                                      /*DRI006*/
000114210907/**/                                                                                  /*DRI006*/
000115210907/* PERFORM ONLY IF GLC39 00002  */                                                    /*DRI006*/
000116210907/**/                                                                                  /*DRI006*/
000117210907             IF         COND(&FORB *EQ 'B') THEN(DO) /*DRI006*/
000118210907                                                                                      /*DRI006*/
000119210907/**/                                                                                  /*DRI006*/
000120210907/* CHECK IF DRI006 IS INSTALLED */                                                    /*DRI006*/
000121210907/**/                                                                                  /*DRI006*/
000122210907                CHGVAR     VAR(&RTCD) VALUE('       ') /*DRI006*/
000123210907                CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'DRI006' &AOFMT) /*DRI006*/
000125210907                                                                                      /*DRI006*/
000126210907/* IF FEATURE DRI006 IS 'ON' */                                                       /*DRI006*/
000127210907                                                                                      /*DRI006*/
000128210907                IF         COND(&RTCD *EQ ' ') THEN(DO) /*DRI006*/
000129210907                   CHGVAR     VAR(&DRI006) VALUE('Y') /*DRI006*/
000130210907                ENDDO      /*DRI006*/
000131210907                                                                                      /*DRI006*/
000132210907/**/                                                                                  /*DRI006*/
000133210907/* CHECK IF SYSTEM VALUE FOR THE LIBRARY WHERE ACCNTAB WILL BE COPIED */              /*DRI006*/
000134210907/**/                                                                                  /*DRI006*/
000135210907                                                                                      /*DRI006*/
000136210907                CHGVAR     VAR(&PRTCD) VALUE('       ') /*DRI006*/
000137210907                                                                                      /*DRI006*/
000138210907                CALL       PGM(AOSVALR0) PARM(&PRTCD &POPV01 &PVL01 &POP02 &PVL02 &POP03 +
000139210907                             &PVL03 &POP04 &PVL04 &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
000140210907                             &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10) /*DRI006*/
000142210907                                                                                      /*DRI006*/
000143210907                IF         COND(&PRTCD *EQ '       ' *AND &DRI006 *EQ 'Y') THEN(DO) /*DRI006*/
000145210907                                                                                      /*DRI006*/
000146210907                   CHGVAR     VAR(&SVALLIB) VALUE(%SST(&PVL01 1 10)) /*DRI006*/
000147210907                                                                                      /*DRI006*/
000148210907                   CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&SYSID) /*DRI006*/
000149210907                                                                                      /*DRI006*/
000150210907/* CHECK IF EOM AND IF SO, MAKE A COPY OF ACCNTAB */                                  /*DRI006*/
000151210907                                                                                      /*DRI006*/
000152210907                   CALL       PGM(SD2000) PARM(&EOM &EOY &ERROR) /*DRI006*/
000153210907                                                                                      /*DRI006*/
000154210907                   IF         COND(&EOM *EQ 'Y' *AND &ERROR *EQ ' ') THEN(DO) /*DRI006*/
000156210907                                                                                      /*DRI006*/
000157210907                      CPYF       FROMFILE(&DMLIB/ACCNTAB) TOFILE(&SVALLIB/ACCNTAB) +
000158210907                                   MBROPT(*REPLACE) CRTFILE(*YES) /*DRI006*/
000160210907                                                                                      /*DRI006*/
000161210907                   ENDDO      /*DRI006*/
000162210907                                                                                      /*DRI006*/
000163210907                   IF         COND(&ERROR *EQ 'Y') THEN(DO) /*DRI006*/
000164210907                                                                                      /*DRI006*/
000165210907                      SNDPGMMSG  MSG('SD2000 - PROGRAM ERROR') TOMSGQ(MOPERQ) /*DRI006*/
000167210907                      CHGJOB     SWS(XXXXXXX1)
000168210907                                                                                      /*DRI006*/
000169210907                   ENDDO      /*DRI006*/
000170210907                                                                                      /*DRI006*/
000171210907                ENDDO      /*DRI006*/
000172210907                                                                                      /*DRI006*/
000173210907             ENDDO      /*DRI006*/
000174210907                                                                                      /*DRI006*/
000175210907/**********************************************************************/
000176210907/* End of /COPY DRI006_002                                           **/
000177210907/**********************************************************************/
