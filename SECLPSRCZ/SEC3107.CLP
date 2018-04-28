/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Interface Index Ref. Maint.')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC3107  -  EXTEL INTERFACE INDEX REFERENCE MAINTENANCE    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117            DATE  10JAN91             */
/*       PREV AMEND NO. S01179            DATE  16/09/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       Description of Amendment.                                  */
/*       No. S01117    Text:      MULTIBRANCHING                    */
/*       No. S01179    Text:      AS  - RELEASE                     */
/*                                                                  */
/*                                                                  */
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
/*******DCL        &DATA  *CHAR  44                                  * *S01117*/
        DCL        &DATA  *CHAR  50                                   /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
 
        CHGJOB     SWS(XXXXXX00)
 
        CALL       SE3107
 
/*   Check for Database errors trapped by the program                       **/
 
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/************RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&DATA)        * *S01117*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&DATA)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
