/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Communication Device Check')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC3111A  -  EXTEL COMMUNICATION DEVICE CHECK              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117            DATE  11JAN91             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ)                                   /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
      DCL    &INFO        *CHAR     61         /* *CAT of next 3              */
      DCL    &EXEF        *CHAR      1         /* Extel error flag            */
      DCL    &STNR        *CHAR     30         /* Status narr                 */
      DCL    &TRSN        *CHAR     30         /* Termination reason          */
/*****DCL    &DATA        *CHAR     44         /* LDA data           * *S01117*/
      DCL    &DATA        *CHAR     50         /* LDA data            /*S01117*/
      DCL    VAR(&RSEQ) TYPE(*CHAR) LEN(5)                            /*S01117*/
 
 
/*---------------------------------------------------------------------*/
 
 SNDUSRMSG  MSG('EXTEL Device Check') MSGTYPE(*INFO) TOMSGQ(MOPERQ)
 
/*---------------------------------------------------------------------*/
 
/*  Check the Line, Device & Control unit by varying line off & on     */
 
             VRYCFG     CFGOBJ(EXTELDEVD) CFGTYPE(*DEV) STATUS(*OFF)
              MONMSG     MSGID(CPF2640) EXEC(GOTO VRYERR)
 
             VRYCFG     CFGOBJ(EXTELCUD) CFGTYPE(*CTL) STATUS(*OFF)
              MONMSG     MSGID(CPF2640) EXEC(GOTO VRYERR)
 
             VRYCFG     CFGOBJ(EXTELLIND) CFGTYPE(*LIN) STATUS(*OFF)
              MONMSG     MSGID(CPF2640) EXEC(GOTO VRYERR)
 
             VRYCFG     CFGOBJ(EXTELLIND) CFGTYPE(*LIN) STATUS(*ON)
              MONMSG     MSGID(CPF2640) EXEC(GOTO VRYERR)
 
             VRYCFG     CFGOBJ(EXTELCUD) CFGTYPE(*CTL) STATUS(*ON)
              MONMSG     MSGID(CPF2640) EXEC(GOTO VRYERR)
 
             VRYCFG     CFGOBJ(EXTELDEVD) CFGTYPE(*DEV) STATUS(*ON)
              MONMSG     MSGID(CPF2640) EXEC(GOTO VRYERR)
 
/*---------------------------------------------------------------------*/
 
/*  If no error skip error processing                                  */
 
              GOTO  ENDPGM
 
/*---------------------------------------------------------------------*/
 
/*  If error on Device Check                                           */
 
 VRYERR:      CHGVAR     &EXEF ('Y')
              CHGVAR     &TRSN ('DEVICE ERROR                  ')
              CHGVAR     &STNR ('DEVICE ERROR                  ')
 
              CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
              CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
              CHGJOB     SWS(XXXXX1XX)
              SNDUSRMSG  MSG('EXTEL Device Error') MSGTYPE(*INFO) +
                           TOMSGQ(MOPERQ)
 
/*  Call the Wire reception program to output error to PF/EXLNKD       */
 
              CALL SE3110
 
/*  Update EXSTAT & access LDA if database error                        */
 
              IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
 
                 CHGVAR     &EXEF ('Y')
                 CHGVAR     &TRSN ('DATABASE ERROR IN SE3110      ')
                 CHGVAR     &STNR ('DATABASE ERROR IN SE3110      ')
 
                 CHGVAR     &INFO (&EXEF *CAT &TRSN *CAT &STNR)
                 CHGDTAARA  DTAARA(EXSTAT (77 61))  VALUE(&INFO)
 
/****************RTVDTAARA  DTAARA(LDA (134 44))   RTNVAR(&DATA)     * *S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&DATA)      /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
              ENDDO
 
/*  Produce a report of the error.                                      */
 
/*************CALL SEC3113                                           * *S01117*/
              CALL       PGM(SEC3113) PARM(&RSEQ)                     /*S01117*/
 
/*---------------------------------------------------------------------*/
 
 
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
 
