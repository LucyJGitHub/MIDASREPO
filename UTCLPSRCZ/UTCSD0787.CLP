000100191014/*********************************************************************/
000200191014/*STD    CLPBASE                                                     */
000300191014/*EXI    TEXT('Midas  SD MD-53116 Utility program for T_GZCUSTEX')   */
000400191014/*********************************************************************/
000500191014/*                                                                   */
000600191014/*       Midas - Standing Data Module                                */
000700191014/*                                                                   */
000800191014/*       UTCSD0787 - Midas  SD MD-53116 Utility pgm                  */
000900191014/*                   (CL program to call ILE/UTSD0787)               */
001000191014/*                                                                   */
001100191014/*       (c) Finastra International Limited 2016                     */
001200191014/*                                                                   */
001300191014/*       Last Amend No. MD053116  *CREATE  Date 08Oct19              */
001400191014/*                                                                   */
001500191014/*********************************************************************/
001600191014/*                                                                   */
001700191014/*       MD053116 - Customer Deactivated but not displayed as        */
001800191014/*                  inactive.                                        */
001900191014/*                                                                   */
002000191014/*********************************************************************/
002100191014             PGM        PARM(&MODE)
002200191014/**/
002300191014             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
002400191014             DCL        VAR(&GMLIB) TYPE(*CHAR) LEN(10)
002500191014             DCL        VAR(&GPLIB) TYPE(*CHAR) LEN(10)
002600191014             DCL        VAR(&GLOBID) TYPE(*CHAR) LEN(2)
002700191014             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
002800191014             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
002900191014                          Finastra International Limited 2016')
003000191014/**/
003100191014/*/COPY SDCPYSRC,SDSVALDCL                                                                        */
003200191014/**/
003300191014/* Global monitor message */
003400191014/**/
003500191014             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
003600191014                          CMDLBL(ABNOR1))
003700191014/**/
003800191014/* Start of program */
003900191014/**/
004000191014             SNDPGMMSG  MSG('UTCSD0787 - MD-53116 Utility Program+
004100191014                          for T_GZCUSTEX') TOMSGQ(MRUNQ MOPERQ)
004200191014/**/
004300191014/* Create LDA if it doesn't exist */
004400191014/**/
004500191014             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
004600191014             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
004700191014             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
004800191014             ENDDO
004900191014/**/
005000191014/* Passed parameter is invalid */
005100191014/**/
005200191014             IF         COND((&MODE *NE 'A') *AND (&MODE *NE +
005300191014                          'a') *AND (&MODE *NE 'U')  +
005400191014                          *AND (&MODE *NE 'u')) THEN(DO)
005500191014/**/
005600191014             SNDPGMMSG  MSG('Invalid parameter passed to UTCSD0787') +
005700191014                             TOMSGQ(MOPERQ MRUNQ)
005800191014             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
005900191014                          parameter passed. It should either be ''U'' +
006000191014                          ''u'' for Update and ''A'' or ''a'' for +
006100191014                          Audit.') MSGTYPE(*ESCAPE)
006200191014             GOTO       CMDLBL(END)
006300191014             ENDDO
006400191014/**/
006500191014             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
006600191014                        THEN(DO)
006700191014/**/
006800191014/*  Determine global system ID.                                                                   */
006900191014/**/
007000191014             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC 'GlobalSystemPrefix' +
007100191014                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
007200191014                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
007300191014                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
007400191014                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)
007500191014/**/
007600191014/* If there is an error finding system values, then end abnormally.                               */
007700191014/**/
007800191014             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
007900191014                             CMDLBL(ABNOR1))
008000191014/**/
008100191014/*  Define names of global libraries.                                                             */
008200191014/**/
008300191014             CHGVAR     VAR(&GLOBID) VALUE(&SVAL1)
008400191014             CHGVAR     VAR(&GPLIB) VALUE(&GLOBID *TCAT 'GPLIB')
008500191014             CHGVAR     VAR(&GMLIB) VALUE(&GLOBID *TCAT 'GMLIB')
008600191014/**/
008700191014/* Check if Y_GZCUSTEX exists */
008800191014/**/
008900191014             CHKOBJ     OBJ(&GPLIB/Y_GZCUSTEX) OBJTYPE(*FILE)
009000191014             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FLECHK))
009100191014             DLTF       FILE(Y_GZCUSTEX)
009200191014/**/
009300191014FLECHK:      CHKOBJ     OBJ(&GPLIB/Y_GZCUSTEX) OBJTYPE(*FILE)
009400191014             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
009500191014             DLTF       FILE(Y_GZCUSTEX)
009600191014/**/
009700191014/* Create backup of PF/T_GZCUSTEX  */
009800191014/**/
009900191014BACKUP:      CPYF       FROMFILE(&GMLIB/T_GZCUSTEX) +
010000191014                          TOFILE(&GPLIB/Y_GZCUSTEX) MBROPT(*REPLACE) +
010100191014                          CRTFILE(*YES)
010200191014             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
010300191014             CLRPFM     FILE(Y_GZCUSTEX)
010400191014             ENDDO
010500191014             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
010600191014             SNDUSRMSG  MSG('Error occurred in copying PF/T_GZCUSTEX +
010700191014                          tO PF/Y_GZCUSTEX. Process terminated.') +
010800191014                          MSGTYPE(*INFO)
010900191014             GOTO       CMDLBL(END)
011000191014             ENDDO
011100191014
011200191014             ENDDO
011300191014/**/
011400191014/* Call ILE/UTSD0787 */
011500191014/**/
011600191014             CHGJOB     SWS(XXXXXX00)
011700191014             CHGVAR     VAR(&RUNP) VALUE('YES')
011800191014
011900191014             CALL       PGM(UTSD0787) PARM(&MODE)
012000191014/**/
012100191014/* Error occurred in audit program */
012200191014/**/
012300191014             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
012400191014                          CMDLBL(ABNOR))
012500191014
012600191014             SNDPGMMSG  MSG('UTCSD0787 completed normally.') +
012700191014                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
012800191014
012900191014             GOTO       CMDLBL(END)
013000191014
013100191014/**/
013200191014/* Abnormal Termination of the program or */
013300191014/* Restore backup if an error occurred in update mode */
013400191014/**/
013500191014ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
013600191014                        THEN(DO)
013700191014             IF         COND(&RUNP *EQ 'YES') THEN(DO)
013800191014
013900191014             CPYF       FROMFILE(&GPLIB/Y_GZCUSTEX) +
014000191014                        TOFILE(&GMLIB/T_GZCUSTEX) MBROPT(*REPLACE) +
014100191014                        FMTOPT(*NONE)
014200191014             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
014300191014             SNDUSRMSG  MSG('Error occurred in restoring PF/T_GZCUSTEX+
014400191014                           from PF/Y_GZCUSTEX. Process terminated.  +
014500191014                          Please restore PF/T_GZCUSTEX manually from +
014600191014                          PF/Y_GZCUSTEX.') +
014700191014                          MSGTYPE(*INFO)
014800191014             ENDDO
014900191014
015000191014             ENDDO
015100191014             ENDDO
015200191014
015300191014ABNOR1:      SNDPGMMSG  MSG('Error occurred in UTCSD0787 program') +
015400191014                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
015500191014
015600191014END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
015700191014                          Limited 2016')
015800191014             SNDPGMMSG  MSG('End of UTCSD0787') TOMSGQ(MRUNQ MOPERQ)
015900191014             ENDPGM
