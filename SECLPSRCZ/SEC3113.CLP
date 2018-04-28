/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Link Report')                          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC3113  -  EXTEL LINK REPORT                              */
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
      DCL    &DATE        *CHAR      6         /* System date                 */
      DCL    &TIME        *CHAR      6         /* System time                 */
      DCL    &QDATFMT     *CHAR      3         /* System date format          */
/*****DCL    &DATA        *CHAR     44         /* LDA data           * *S01117*/
      DCL    &DATA        *CHAR     50         /* LDA data            /*S01117*/
      DCL    VAR(&RSEQ) TYPE(*CHAR) LEN(5)                            /*S01117*/
 
 
 SNDUSRMSG  MSG('EXTEL Link Report') MSGTYPE(*INFO) TOMSGQ(MOPERQ)
 
 
/*  Retreive System Date and place in EXSTAT   (finish date)            */
 
        RTVJOBA    DATE(&DATE)
        CHGDTAARA  DTAARA(EXSTAT (64 6))   VALUE(&DATE)
        RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
        CHGDTAARA  DTAARA(EXSTAT (70 6))   VALUE(&TIME)
 
        RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&QDATFMT)
 
/*******CALL       SE3113    PARM(&QDATFMT)                          * *S01117*/
        CALL       PGM(SE3113) PARM(&QDATFMT &RSEQ)                   /*S01117*/
 
/*  Access LDA if database error                                       */
 
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
 
/************RTVDTAARA  DTAARA(LDA (134 44))   RTNVAR(&DATA)         * *S01117*/
             RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&DATA)          /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
             ENDDO
 
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
