/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Initial Set Up')                       */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*    SEC3114- EXTEL Initial Set Up.                                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    Last Amend No.S01117                   Date 11JAN91           */
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
        PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/*******DCL        &DATA     *CHAR      44        /* DB ERROR INFO.  * *S01117*/
        DCL        &DATA     *CHAR      50        /* DB ERROR INFO.   /*S01117*/
        DCL        &RMSG     *CHAR       6        /* EXTEL Bank Code */
 
        CHGJOB     SWS(00000000)
 
        CLRPFM     EXCCYZ
        CLRPFM     EXINDZ
        CLRPFM     EXPRCZ
        CLRPFM     EXVALZ
        CLRPFM     HIINDZ
 
 
/*       Call program to set up trailers & data area EXSTAT.            */
 
        CALL      SE3114
 
/*       Check for database errors trapped by the program,              */
/*         send program message.                                        */
 
        IF        COND(%SWITCH(XXXXXX11))   THEN(DO)
/*****************RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&DATA)   * *S01117*/
                  RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&DATA)    /*S01117*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                      TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
        ENDPGM
