000100210908/*********************************************************************/
000101210908/*STD    CLPBASE                                                     */
000102210908/*EXI    TEXT('Midas XX ETL Extract Requirements')                   */
000103210908/*********************************************************************/
000104210908/*                                                                   */
000105210908/*       Midas - Standing Data Module                                */
000106210908/*                                                                   */
000107210908/*       XXC005005 - Midas XX ETL Extract Requirements               */
000108210908/*                                                                   */
000109210908/*       (c) Finastra International Limited 2021                     */
000110210908/*                                                                   */
000111210908/*       Last Amend No. DRI007  *CREATE    Date 16Aug21              */
000112210908/*                                                                   */
000113210908/*********************************************************************/
000114210908/*                                                                   */
000115210908/*       DRI007 - ETL Extract Requirements                           */
000116210908/*                                                                   */
000117210908/*********************************************************************/
000118210908             PGM
000119210908
000120210908             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra International +
000121210908                          Limited 2021')
000122210908             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
000123210908             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
000124210908
000125210908             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
000126210908             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)
000127210908             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)
000128210908             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
000129210908             DCL        VAR(&DRI007) TYPE(*CHAR) LEN(1)
000130210908
000131210908             DCL        VAR(&POPTN1) TYPE(*CHAR) LEN(20)
000132210908             DCL        VAR(&POPTN2) TYPE(*CHAR) LEN(20)
000133210908             DCL        VAR(&POPTN3) TYPE(*CHAR) LEN(20)
000134210908             DCL        VAR(&PVAL1) TYPE(*CHAR) LEN(200)
000135210908             DCL        VAR(&PVAL2) TYPE(*CHAR) LEN(200)
000136210908             DCL        VAR(&PVAL3) TYPE(*CHAR) LEN(200)
000137210908
000138210908             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(10)
000139210908             DCL        VAR(&BKSLIB) TYPE(*CHAR) LEN(8)
000140210908             DCL        VAR(&BKPLIBT) TYPE(*CHAR) LEN(2)
000141210908             DCL        VAR(&BKLIB) TYPE(*CHAR) LEN(10)
000142210908
000143210908             DCL        VAR(&BKDAY) TYPE(*DEC) LEN(2 0) VALUE(1)
000144210908             DCL        VAR(&ZDYNBR) TYPE(*DEC) LEN(5 0) VALUE(0)
000145210908             DCL        VAR(&BJRDNB) TYPE(*DEC) LEN(5 0)
000146210908             DCL        VAR(&BJLCCY) TYPE(*CHAR) LEN(3)
000147210908             DCL        VAR(&BJSLCD) TYPE(*CHAR) LEN(3)
000148210908             DCL        VAR(&BJBVPD) TYPE(*DEC) LEN(3 0)
000149210908             DCL        VAR(&BJDFIN) TYPE(*CHAR) LEN(1)
000150210908             DCL        VAR(&DATETO) TYPE(*DEC) LEN(6 0)
000151210908             DCL        VAR(&DATETOT) TYPE(*CHAR) LEN(7)
000152210908             DCL        VAR(&DATE3) TYPE(*CHAR) LEN(7)
000153210908
000154210908             DCLF       FILE(XXETLEXPD)
000155210908/**/
000156210908/*    Global monitor message                                         */
000157210908/**/
000158210908             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
000160210908
000161210908             SNDPGMMSG  MSG('XXC005004 - Midas XX ETL Extract Requirements') TOMSGQ(MRUNQ)
000163210908
000164210908/**/
000165210908             CHGJOB     SWS(00000000)
000166210908
000167210908/**/
000168210908/* Check if DRI007 is ON */
000169210908/**/
000170210908             CHGVAR     VAR(&PRTCD) VALUE('       ')
000171210908             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
000172210908             CHGVAR     VAR(&PSARD) VALUE('DRI007')
000173210908             CHGVAR     VAR(&DRI007) VALUE('N')
000174210908
000175210908             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)
000176210908
000177210908             IF         COND(&PRTCD *EQ '       ') THEN(DO)
000178210908                CHGVAR     VAR(&DRI007) VALUE('Y')
000179210908             ENDDO
000180210908
000181210908/* Process only if DRI007 is ON */
000182210908
000183210908             IF         COND(&DRI007 *EQ 'Y') THEN(DO)
000184210908
000185210908/* Check system values for ETL library names */
000186210908
000187210908                CHGVAR     VAR(&PRTCD) VALUE(*BLANKS)
000188210908                CHGVAR     VAR(&POPTN1) VALUE('ETLExtractLib')
000189210908                CHGVAR     VAR(&PVAL1) VALUE(*BLANKS)
000190210908                CHGVAR     VAR(&POPTN2) VALUE('ETLBackupLib')
000191210908                CHGVAR     VAR(&PVAL2) VALUE(*BLANKS)
000192210908
000193210908                CALL       PGM(AOSVALR0) PARM(&PRTCD &POPTN1 &PVAL1 &POPTN2 &PVAL2 &POPTN3 +
000194210908                             &PVAL3 &POPTN3 &PVAL3 &POPTN3 &PVAL3 &POPTN3 &PVAL3 &POPTN3 +
000195210908                             &PVAL3 &POPTN3 &PVAL3 &POPTN3 &PVAL3 &POPTN3 &PVAL3)
000197210908
000198210908                IF         COND(&PRTCD *NE '       ') THEN(DO)
000199210908                   GOTO       CMDLBL(ABNOR)
000200210908                ENDDO
000201210908
000202210908                IF         COND(&PRTCD *EQ '       ') THEN(DO)
000203210908                   CHGVAR     VAR(&EXTLIB) VALUE(&PVAL1)
000204210908                   CHGVAR     VAR(&BKSLIB) VALUE(&PVAL2)
000205210908
000206210908                   IF         COND(&EXTLIB = '          ' *OR &BKSLIB = '        ') THEN(DO)
000208210908                      GOTO       CMDLBL(ABNOR)
000209210908                   ENDDO
000210210908
000211210908                ENDDO
000212210908
000213210908/* Allocate main library for safe operations                                       */
000214210908
000215210908                ALCOBJ     OBJ((&EXTLIB *LIB *EXCLRD))
000216210908
000217210908/* Determine the backup data library name for the previous run                     */
000218210908
000219210908                CALL       PGM(XXC005006) PARM(&BJRDNB &BJLCCY &BJSLCD &BJBVPD &BJDFIN)
000221210908                CALL       PGM(ZBKDT) PARM(&BJRDNB &BKDAY &ZDYNBR &BJLCCY &BJSLCD)
000222210908                CALL       PGM(ZDATE2) PARM(&ZDYNBR &BJDFIN &DATETO &DATE3)
000223210908
000224210908                IF         COND(%SST(&DATE3 1 1) = ' ') THEN(DO)
000225210908                   CHGVAR     VAR(&DATETOT) VALUE('0' *CAT %TRIM(&DATE3))
000226210908                   CHGVAR     VAR(&BKPLIBT) VALUE(%SST(&DATETOT 1 2))
000227210908                ENDDO
000228210908                ELSE       DO
000229210908                   CHGVAR     VAR(&BKPLIBT) VALUE(%SST(&DATE3 1 2))
000230210908                ENDDO
000231210908                CHGVAR     VAR(&BKLIB) VALUE(&BKSLIB *TCAT &BKPLIBT)
000232210908
000233210908/* Check if the backup data library exists and if not create it                    */
000234210908
000235210908                CHKOBJ     OBJ(&BKLIB) OBJTYPE(*LIB)
000236210908                MONMSG     MSGID(CPF9801) EXEC(CRTLIB LIB(&BKLIB))
000237210908
000238210908/* Allocate backup library for safe operations                                     */
000239210908
000240210908                ALCOBJ     OBJ((&BKLIB *LIB *EXCLRD))
000241210908
000242210908/* Clear backup library                                                            */
000243210908
000244210908                CLRLIB     LIB(&BKLIB)
000245210908
000246210908/* Copy previous extraction to backup library                                      */
000247210908
000248210908                CRTDUPOBJ  OBJ(*ALL) FROMLIB(&EXTLIB) OBJTYPE(*ALL) TOLIB(&BKLIB) DATA(*YES) +
000249210908                             CST(*NO) TRG(*NO)
000250210908
000251210908/* Clear extract library                                                           */
000252210908
000253210908                CLRLIB     LIB(&EXTLIB)
000254210908
000255210908/* Copy new files                                                                  */
000256210908
000257210908 READ:          RCVF
000258210908                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
000259210908
000260210908                CPYF       FROMFILE(&XXFILE) TOFILE(&EXTLIB/&XXFILE) MBROPT(*REPLACE) +
000261210908                             CRTFILE(*YES)
000262210908                MONMSG     MSGID(CPF2802 CPF2817) EXEC(DO)
000263210908                   SNDPGMMSG  MSGID(DRI0701) MSGF(GBXXUSRMSG) MSGDTA(&XXFILE) TOMSGQ(MOPERQ)
000265210908                   MONMSG     MSGID(CPF0000 MCH0000)
000266210908                ENDDO
000267210908
000268210908                GOTO       CMDLBL(READ)
000269210908
000270210908/* Complete gracefully                                                             */
000271210908
000272210908                GOTO       CMDLBL(ENDPGM)
000273210908
000274210908             ENDDO
000275210908
000276210908
000277210908             GOTO       CMDLBL(ENDPGM)
000278210908
000279210908 ABNOR:
000280210908             CHGJOB     SWS(XXXXXX11)
000281210908
000282210908/* Abnormal termination */
000283210908
000284210908             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC005005 ended +
000285210908                          abnormally - see job log') TOMSGQ(MOPERQ)
000286210908             MONMSG     MSGID(CPF0000 MCH0000)
000287210908
000288210908 ENDPGM:
000289210908             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited 2021')
000291210908
000292210908             ENDPGM
