/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Interface Monitor')                    */
/********************************************************************/
/*                                                                  */
/*       Midas     - Securities Trading Module                      */
/*                                                                  */
/*       SEC3109  -  EXTEL INTERFACE MONITOR                        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 078893            DATE  16NOV94             */
/*       PREV AMEND NO. S01117            DATE  10JAN91             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       078893    - EXTEL MONITOR SHOULD NOT APPEAR DURING THE NEW */
/*                   COB (FIX TO S01495)                            */
/*       S01117    - MULTIBRANCHING                                 */
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
/*******DCL        &DATA   *CHAR   44                                * *S01117*/
        DCL        &DATA   *CHAR   50                                 /*S01117*/
        DCL        &EXST   *CHAR    1
 
        CHGJOB     SWS(00000000)
 
/*  Skip if link & updates have finished                               */
 
        RTVDTAARA   DTAARA(EXSTAT (76 1))   RTNVAR(&EXST)
 
        IF         COND(&EXST *EQ 'F')   THEN(DO)
                   CHGDTAARA   DTAARA(EXSTAT (146 1))  VALUE(N)
                   SNDPGMMSG MSG('EXTEL processing complete') +
                                  TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO  ENDPGM
        ENDDO
 
/***Display*status*information**************************************/ /*078893*/
 
/*******CALL       SE3109  **/                                        /*078893*/
 
/*   Check for Database errors trapped by the program                       **/
 
/*******IF***COND(%SWITCH(XXXXXX11))   THEN(DO) **/                   /*078893*/
/************RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&DATA)        * *S01117*/
/************RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&DATA)  /*S01117*078893*/
/************    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) + *078893*/
/************      TOPGMQ(*EXT) TOMSGQ(MOPERQ) **/                    /*078893*/
/*******ENDDO **/                                                     /*078893*/
 
 
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
