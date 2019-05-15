/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Global House-keeping')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC210000 - Global House-keeping                            */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD023876           Date 30Apr14              */
/*                      CCB023B            Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG4926 *CREATE    Date 18Nov04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD023876 - GOC210000 Performance Issues                     */
/*       CCB023B - COB Restructure - Input Cycle Termination         */
/*                 Restructuring                                     */
/*       BG18886 - Amend non-standard codes.                         */
/*       BUG4926 - Global House-Keeping                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)
 
             DCL        VAR(&PROC)  TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/**********  DCLF       FILE(SDBANKPD)  */                                               /*CCB023B*/
             DCLF       FILE(SDSBNKTD)                                                   /*CCB023B*/
 
/** GLOBAL MONITOR MESSAGE */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
             CHGJOB     SWS(00000000)
 
/* Get zone */
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
/* error */
/**********  IF         COND(&RTCD**= '       ') THEN(DO)                             */ /*BG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                               /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
 READ:       RCVF
/* EOF. Goto abnormal proessing section */
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ABNOR))
 
/* Determine if it is this zone to do the house-keeping */
 
             CALL       PGM(GP210000) PARM(&RTCD &ERMS &ZOZONE &BJMRDT &PROC)
 
 
/* Error */
/**********   IF         COND(&RTCD**= '       ') THEN(GOTO CMDLBL(ABNOR))            */ /*BG18886*/
              IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ABNOR))              /*BG18886*/
 
/**********   IF         COND(&PROC**= 'Y') THEN(GOTO CMDLBL(END))                    */ /*BG18886*/
              IF         COND(&PROC *NE 'Y') THEN(GOTO CMDLBL(END))                      /*BG18886*/
 
/**GPWTRAPPD*Housekeeping**/                                                            /*MD023876*/
/*********************************************************************/                 /*MD023876*/
/**********  OVRDBF     FILE(GPWTRAPL0X) TOFILE(GPWTRAPL0) SHARE(*NO)*/                 /*MD023876*/
/**********  CALL       PGM(GP210010) PARM(&RTCD &ERMS)              */                 /*MD023876*/
/**********   IF         COND(&RTCD**= '       ') THEN(GOTO CMDLBL(ABNOR))            */ /*BG18886*/
/**********   IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ABNOR)) */  /*BG18886 MD023876*/
/*********************************************************************/                 /*MD023876*/
/**GPUTCIPD*Housekeeping**/                                                             /*MD023876*/
/*********************************************************************/                 /*MD023876*/
/**********  CALL       PGM(GP210020) PARM(&RTCD &ERMS)              */                 /*MD023876*/
/**********   IF         COND(&RTCD**= '       ') THEN(GOTO CMDLBL(ABNOR))            */ /*BG18886*/
/**********   IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ABNOR)) */  /*BG18886 MD023876*/
 
/* GPSOLOGPD Housekeeping  */
 
             CALL       PGM(GP210030) PARM(&RTCD &ERMS)
/**********   IF         COND(&RTCD *= '       ') THEN(GOTO CMDLBL(ABNOR))            */ /*BG18886*/
              IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ABNOR))              /*BG18886*/
 
/* GPSBLOGPD Housekeeping */
 
             CALL       PGM(GP210040) PARM(&RTCD &ERMS)
/**********   IF         COND(&RTCD *= '       ') THEN(GOTO CMDLBL(ABNOR))            */ /*BG18886*/
              IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ABNOR))              /*BG18886*/
 
/* GPULOGPD Housekeeping  */
 
             CALL       PGM(GP210050) PARM(&RTCD &ERMS)
/**********   IF         COND(&RTCD *= '       ') THEN(GOTO CMDLBL(ABNOR))            */ /*BG18886*/
              IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ABNOR))              /*BG18886*/
 
/* GPELOGPD Housekeeping  */
 
             CALL       PGM(GP210060) PARM(&RTCD &ERMS)
/**********   IF         COND(&RTCD *= '       ') THEN(GOTO CMDLBL(ABNOR))            */ /*BG18886*/
              IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ABNOR))              /*BG18886*/
 
 
              GOTO CMDLBL(END)
 
 /** ABNORMAL ERROR PROCESSING                                      */
  ABNOR:      SNDPGMMSG  MSG('PROGRAM GOC210000 ENDED ABNORMALLY') +
                           TOMSGQ(MOPERQ)
              MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
              CHGJOB     SWS(XXXXXX11)
 
 END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                           Finastra International Limited')
              ENDPGM
