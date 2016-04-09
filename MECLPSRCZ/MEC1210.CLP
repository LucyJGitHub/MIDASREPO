/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME End I.M.M. COB activity control')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                   */
/*                                                                   */
/*       MEC1210  - End I.M.M. C.O.B. Activity Control               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 092425             DATE 09SEP95              */
/*                      092957             DATE 09SEP95              */
/*                      S01408             DATE 05MAY95              */
/*                      S01435             DATE 19AUG93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   CCB009 - Journal files throughout close of business             */
/*   092425 - Allocation of the JLIB during generic delete of the    */
/*            receivers causes other components to be locked out -   */
/*            in any case, only one receiver is created, so delete   */
/*            it by name to prevent locks (apply the original        */
/*            version of fix 092957)                                 */
/*   092957 - If DLTJRN fails because pgm cannot allocate xxJLIB     */
/*            retry before failing.                                  */
/*       S01408 - Addition of core hook MEC1210MPS                   */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*092957*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,MEC1210001                                          */
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('MEC1210 - End I.M.M. C.O.B. Activity +
                          Control') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/*/COPY WNCPYSRC,MEC1210002                                          */
/* */
/* Format JLIB name */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&JLIB) VALUE(&DBPREFIX *CAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MEC1210MPS                                          */
                                                                      /*S01408*/
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Update status to Active only if not called from MEC1200 */
/* */
             IF         COND(&COMP_NAME *NE 'MEC1200   ') THEN(DO)
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
             ENDDO
/* */
RETRY:                                                                /*092957*/
/* End journaling on  files to MECOBJRN in JLIB */
/* */
/*/COPY WNCPYSRC,MEC1210003                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/MECOBJRN)
             MONMSG     MSGID(CPF9801)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(DLTFAIL))     /*092957*/
/* */
/* Change job to answer escape messages with default */
/* */
             CHGJOB     INQMSGRPY(*DFT)
             ENDDO                                                    /*CCB009*/
/* */
/* Delete Journal in JLIB */
/* */
             DLTJRN     JRN(&JLIB/MECOBJRN)
             MONMSG     MSGID(CPF2105 CPF9801)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(DLTFAIL))     /*092957*/
/* */
/* Delete Journal receiver in JLIB */
/* */
/************DLTJRNRCV  JRNRCV(&JLIB/MERCV*)                       */ /*092425*/
             DLTJRNRCV  JRNRCV(&JLIB/MERCV001)                        /*092425*/
             MONMSG     MSGID(CPF2105 CPF2125)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(DLTFAIL))     /*092957*/
/*/COPY WNCPYSRC,MEC1210004                                          */
/* */
             GOTO       CMDLBL(BYPASS)                                /*092957*/
                                                                      /*092957*/
DLTFAIL:                                                              /*092957*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*092957*/
             IF         COND(&COUNT *LE 3) THEN(DO)                   /*092957*/
             DLYJOB     DLY(60)                                       /*092957*/
             GOTO       CMDLBL(RETRY)                                 /*092957*/
             ENDDO                                                    /*092957*/
             ELSE       CMD(DO)                                       /*092957*/
             GOTO       CMDLBL(ABNORMAL)                              /*092957*/
             ENDDO                                                    /*092957*/
BYPASS:                                                               /*092957*/
/* Change job back to *RQD */
/* */
             CHGJOB     INQMSGRPY(*RQD)
/* */
/* Update status to Not Active - component finished */
/* */
             IF         COND(&COMP_NAME *NE 'MEC1200   ') THEN(DO)
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1210 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1210 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
