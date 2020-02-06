/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas App Jrn Chg to FF Files on BackupMch')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Restart Recovery Module                    */
/*                                                                   */
/*     SDC1747 - APPLY JOURNAL CHANGES TO FF MULTIMEMBER FILES       */
/*               ON BACKUP MACHINE                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 23May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E20839             Date 27Feb90              */
/*                      E00000            DATE 00/00/00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       E20839  -  EOD RUNS IN 38 MODE NOT NATIVE BECAUSE             *E20839*/
/*                  QCAEXEC IS CALLED AND NOT QCMDEXC                  *E20839*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MRKT &FRPNT &TOPNT &LRCV)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FRPNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOPNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LRCV) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FRPNA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOPNA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(560)
/**/
             DCLF       FILE(FFMMFD)
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/* SET UP PF/FFMMFD WITH THE PHYSICAL FILE NAMES & THE APPROPRIATE   */
/* MEMBER NAME FOR THE APYJRNCHG COMMAND                             */
/**/
             CLRPFM     FILE(FFMMFD)
             CALL       PGM(SD1742) PARM(&MRKT)
/**/
/* CONVERT THE NUMERIC VALUES OF FROM AND TO POINTS TO ALPHA VALUES  */
/**/
             CHGVAR     VAR(&FRPNA) VALUE(&FRPNT)
             CHGVAR     VAR(&TOPNA) VALUE(&TOPNT)
/**/
/*   APPLY JOURNAL CHANGES PROCESSING                               */
/**/
/*      THE NAMES OF THE FUTURES & OPTIONS MULTIMEMBER FILES FOR    */
/*      WHICH JOURNAL CHANGES HAVE TO BE APPLIED ARE HELD AS A      */
/*      RECORD ON PF/FFMMFD                                         */
/**/
             RCVF
/**/
/* SETUP THE APPLY JOURNAL CHANGES COMMAND IN A VARIABLE TO EXECUTE  */
/**UNDER*QCAEXEC*AND*CALL*QCAEXEC***********************************/ /*E20839*/
/* UNDER QCMDEXC AND CALL QCMDEXC                                     /*E20839*/
/**/
/* IF BLANK MARKET PARAMETER RECEIVED, FORWARD RECOVER 'OTC' MEMBER  */
/* OTHERWISE FORWARD RECOVER MARKET MEMBER RECEIVED                  */
/**/
/************CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) FILE(' + */ /*BG18886*/
/**************************CAT &FMMF *TCAT ') RCVRNG(ICRCV001 '** +    */ /*BG18886*/
/*************************&LRCV**<') FROMENT('*** &FRPNA *< ') TOENT(+ */ /*BG18886*/
/*************************'*** &TOPNA**< ') CMTBDY(*YES)')             */ /*BG18886*/
             CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) FILE(' +
                          *CAT &FMMF *TCAT ') RCVRNG(ICRCV001 ' +
                          *CAT &LRCV *TCAT ') FROMENT(' *CAT &FRPNA +
                          *TCAT ') TOENT(' *CAT &TOPNA *TCAT ') +
                          CMTBDY(*YES)')                                  /*BG18886*/
/**/
/************CALL*******PGM(QCAEXEC) PARM(&MSG 560)*/                 /*E20839*/
             CALL       PGM(QCMDEXC) PARM(&MSG 560)                   /*E20839*/
/**/
/* IF THE FROM OR TO POINT IS NOT ON A COMMITMENT BOUNDARY, THIS     */
/* IS NOT AN ERROR                                                   */
/**/
             MONMSG     MSGID(CPF7039 CPF7067)
/**/
             GOTO       CMDLBL(END)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1747 - Apply Journal Changes +
                          to FF multimember files on backup machine - +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
