/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Currencies Maintenance')               */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC3106  -  CURRENCIES MAINTENANCE                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01117             Date 10Jan91              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/*                                                                  */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01117*/
 
        CHGJOB     SWS(XXXXX000)
 
             CALL       PGM(SE3106)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
             ROLLBACK
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue') TOPGMQ(*EXT)
             GOTO ENDPGM
             ENDDO
 
 
/*   Check for Database errors trapped by the program                       **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&DATA)        * *S01117*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&DATA)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
