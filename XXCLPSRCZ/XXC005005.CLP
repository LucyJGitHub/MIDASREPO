000100210907                                          /*********************************************************
000101210907/*STD    CLPBASE                                                     */
000102210907/*EXI    TEXT('Midas XX ETL Extract Requirements')                   */
000103210907/*********************************************************************/
000104210907/*                                                                   */
000105210907/*       Midas - Standing Data Module                                */
000106210907/*                                                                   */
000107210907/*       XXC005005 - Midas XX ETL Extract Requirements               */
000108210907/*                                                                   */
000109210907/*       (c) Finastra International Limited 2021                     */
000110210907/*                                                                   */
000111210907/*       Last Amend No. DRI007  *CREATE    Date 16Aug21              */
000112210907/*                                                                   */
000113210907/*********************************************************************/
000114210907/*                                                                   */
000115210907/*       DRI007 - ETL Extract Requirements                           */
000116210907/*                                                                   */
000117210907/*********************************************************************/
000118210907             PGM
000119210907
000120210907             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra International +
000121210907                          Limited 2021')
000122210907             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
000123210907             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
000124210907
000125210907             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
000126210907             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)
000127210907             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)
000128210907             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
000129210907             DCL        VAR(&DRI007) TYPE(*CHAR) LEN(1)
000130210907
000131210907             DCL        VAR(&POPTN1) TYPE(*CHAR) LEN(20)
000132210907             DCL        VAR(&POPTN2) TYPE(*CHAR) LEN(20)
000133210907             DCL        VAR(&POPTN3) TYPE(*CHAR) LEN(20)
000134210907             DCL        VAR(&PVAL1) TYPE(*CHAR) LEN(200)
000135210907             DCL        VAR(&PVAL2) TYPE(*CHAR) LEN(200)
000136210907             DCL        VAR(&PVAL3) TYPE(*CHAR) LEN(200)
000137210907
000138210907             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(10)
000139210907             DCL        VAR(&BKSLIB) TYPE(*CHAR) LEN(8)
000140210907             DCL        VAR(&BKPLIBT) TYPE(*CHAR) LEN(2)
000141210907             DCL        VAR(&BKLIB) TYPE(*CHAR) LEN(10)
000142210907
000143210907             DCL        VAR(&BKDAY) TYPE(*DEC) LEN(2 0) VALUE(1)
000144210907             DCL        VAR(&ZDYNBR) TYPE(*DEC) LEN(5 0) VALUE(0)
000145210907             DCL        VAR(&BJRDNB) TYPE(*DEC) LEN(5 0)
000146210907             DCL        VAR(&BJLCCY) TYPE(*CHAR) LEN(3)
000147210907             DCL        VAR(&BJSLCD) TYPE(*CHAR) LEN(3)
000148210907             DCL        VAR(&BJBVPD) TYPE(*DEC) LEN(3 0)
000149210907             DCL        VAR(&BJDFIN) TYPE(*CHAR) LEN(1)
000150210907             DCL        VAR(&DATETO) TYPE(*DEC) LEN(6 0)
000151210907             DCL        VAR(&DATETOT) TYPE(*CHAR) LEN(7)
000152210907             DCL        VAR(&DATE3) TYPE(*CHAR) LEN(7)
000153210907
000154210907             DCLF       FILE(XXETLEXPD)
000155210907/**/
000156210907/*    Global monitor message                                         */
000157210907/**/
000158210907             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
000160210907
000161210907             SNDPGMMSG  MSG('XXC005004 - Midas XX ETL Extract Requirements') TOMSGQ(MRUNQ)
000163210907
000164210907/**/
000165210907             CHGJOB     SWS(00000000)
000166210907
000167210907/**/
000168210907/* Check if DRI007 is ON */
000169210907/**/
000170210907             CHGVAR     VAR(&PRTCD) VALUE('       ')
000171210907             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
000172210907             CHGVAR     VAR(&PSARD) VALUE('DRI007')
000173210907             CHGVAR     VAR(&DRI007) VALUE('N')
000174210907
000175210907             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)
000176210907
000177210907             IF         COND(&PRTCD *EQ '       ') THEN(DO)
000178210907                CHGVAR     VAR(&DRI007) VALUE('Y')
000179210907             ENDDO
000180210907
000181210907/* Process only if DRI007 is ON */
000182210907
000183210907             IF         COND(&DRI007 *EQ 'Y') THEN(DO)
000184210907
000185210907/* Check system values for ETL library names */
000186210907
000187210907                CHGVAR     VAR(&PRTCD) VALUE(*BLANKS)
000188210907                CHGVAR     VAR(&POPTN1) VALUE('ETLExtractLib')
000189210907                CHGVAR     VAR(&PVAL1) VALUE(*BLANKS)
000190210907                CHGVAR     VAR(&POPTN2) VALUE('ETLBackupLib')
000191210907                CHGVAR     VAR(&PVAL2) VALUE(*BLANKS)
000192210907
000193210907                CALL       PGM(AOSVALR0) PARM(&PRTCD &POPTN1 &PVAL1 &POPTN2 &PVAL2 &POPTN3 +
000194210907                             &PVAL3 &POPTN3 &PVAL3 &POPTN3 &PVAL3 &POPTN3 &PVAL3 &POPTN3 +
000195210907                             &PVAL3 &POPTN3 &PVAL3 &POPTN3 &PVAL3 &POPTN3 &PVAL3)
000197210907
000198210907                IF         COND(&PRTCD *NE '       ') THEN(DO)
000199210907                   GOTO       CMDLBL(ABNOR)
000200210907                ENDDO
000201210907
000202210907                IF         COND(&PRTCD *EQ '       ') THEN(DO)
000203210907                   CHGVAR     VAR(&EXTLIB) VALUE(&PVAL1)
000204210907                   CHGVAR     VAR(&BKSLIB) VALUE(&PVAL2)
000205210907
000206210907                   IF         COND(&EXTLIB = '          ' *OR &BKSLIB = '        ') THEN(DO)
000208210907                      GOTO       CMDLBL(ABNOR)
000209210907                   ENDDO
000210210907
000211210907                ENDDO
000212210907
000213210907/* Allocate main library for safe operations                                       */
000214210907
000215210907                ALCOBJ     OBJ((&EXTLIB *LIB *EXCLRD))
000216210907
000217210907/* Determine the backup data library name for the previous run                     */
000218210907
000219210907                CALL       PGM(XXC005006) PARM(&BJRDNB &BJLCCY &BJSLCD &BJBVPD &BJDFIN)
000221210907                CALL       PGM(ZBKDT) PARM(&BJRDNB &BKDAY &ZDYNBR &BJLCCY &BJSLCD)
000222210907                CALL       PGM(ZDATE2) PARM(&ZDYNBR &BJDFIN &DATETO &DATE3)
000223210907
000224210907                IF         COND(%SST(&DATE3 1 1) = ' ') THEN(DO)
000225210907                   CHGVAR     VAR(&DATETOT) VALUE('0' *CAT %TRIM(&DATE3))
000226210907                   CHGVAR     VAR(&BKPLIBT) VALUE(%SST(&DATETOT 1 2))
000227210907                ENDDO
000228210907                ELSE       DO
000229210907                   CHGVAR     VAR(&BKPLIBT) VALUE(%SST(&DATE3 1 2))
000230210907                ENDDO
000231210907                CHGVAR     VAR(&BKLIB) VALUE(&BKSLIB *TCAT &BKPLIBT)
000232210907
000233210907/* Check if the backup data library exists and if not create it                    */
000234210907
000235210907                CHKOBJ     OBJ(&BKLIB) OBJTYPE(*LIB)
000236210907                MONMSG     MSGID(CPF9801) EXEC(CRTLIB LIB(&BKLIB))
000237210907
000238210907/* Allocate backup library for safe operations                                     */
000239210907
000240210907                ALCOBJ     OBJ((&BKLIB *LIB *EXCLRD))
000241210907
000242210907/* Clear backup library                                                            */
000243210907
000244210907                CLRLIB     LIB(&BKLIB)
000245210907
000246210907/* Copy previous extraction to backup library                                      */
000247210907
000248210907                CRTDUPOBJ  OBJ(*ALL) FROMLIB(&EXTLIB) OBJTYPE(*ALL) TOLIB(&BKLIB) DATA(*YES) +
000249210907                             CST(*NO) TRG(*NO)
000250210907
000251210907/* Clear extract library                                                           */
000252210907
000253210907                CLRLIB     LIB(&EXTLIB)
000254210907
000255210907/* Copy new files                                                                  */
000256210907
000257210907 READ:          RCVF
000258210907                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
000259210907
000260210907                CPYF       FROMFILE(&XXFILE) TOFILE(&EXTLIB/&XXFILE) MBROPT(*REPLACE) +
000261210907                             CRTFILE(*YES)
000262210907                MONMSG     MSGID(CPF2802 CPF2817) EXEC(DO)
000263210907                   SNDPGMMSG  MSGID(DRI0701) MSGF(GBXXUSRMSG) MSGDTA(&XXFILE) TOMSGQ(MOPERQ)
000265210907                   MONMSG     MSGID(CPF0000 MCH0000)
000266210907                ENDDO
000267210907
000268210907                GOTO       CMDLBL(READ)
000269210907
000270210907/* Complete gracefully                                                             */
000271210907
000272210907                GOTO       CMDLBL(ENDPGM)
000273210907
000274210907             ENDDO
000275210907
000276210907
000277210907             GOTO       CMDLBL(ENDPGM)
000278210907
000279210907 ABNOR:
000280210907             CHGJOB     SWS(XXXXXX11)
000281210907
000282210907/* Abnormal termination */
000283210907
000284210907             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC005005 ended +
000285210907                          abnormally - see job log') TOMSGQ(MOPERQ)
000286210907             MONMSG     MSGID(CPF0000 MCH0000)
000287210907
000288210907 ENDPGM:
000289210907             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited 2021')
000291210907
000292210907             ENDPGM
