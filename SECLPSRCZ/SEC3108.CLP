/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL Interface Control Maint.')             */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC3108  -  EXTEL INTERFACE CONTROL MAINTENANCE            */
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
/*       No. S01179     Text:     AS  - RELEASE                     */
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
        DCL        &EXST  *CHAR   1          /* Extel status                  */
        DCL        &MNTF  *CHAR   1          /* Maintenance flag              */
/*******DCL        &DATA  *CHAR  44                                  * *S01117*/
        DCL        &DATA  *CHAR  50                                   /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
 
        CHGJOB     SWS(00000000)
 
/*   Not allowed to proceed if updates still running                         +
                                                                             +
     Valid EXTEL status.   Reason to rerun program.                          +
     A - Awaiting data     Wire communication failed before trans-           +
                           mission. eg Device error.                         +
     T - Transmission      Wire communication failed during trans-           +
         of data           mission or tape take on failed.                   +
     C - Transmission      A wire/tape transmission complete but wrong       +
         complete          data sent or no updates done.                     +
     F - All processing    Normal set up for next transmission.              +
         finished                                                            +
                                                                             +
     End if other programs using EXSTAT.                                     */
 
        RTVDTAARA  DTAARA(EXSTAT (146 1))     RTNVAR(&MNTF)
 
        IF   COND(&MNTF *EQ 'Y') THEN(DO)
             SNDPGMMSG  MSG('Job cannot be run now') TOPGMQ(*EXT) +
               TOMSGQ(MOPERQ)
             GOTO  ENDPGM
             ENDDO
 
/*   In case flag is other than N.    (eg E - job cancellation)              */
 
        CHGDTAARA  DTAARA(EXSTAT (146 1))     VALUE('N')
 
/*   Retrieve status                                                         */
 
        RTVDTAARA  DTAARA(EXSTAT (76 1))     RTNVAR(&EXST)
 
/*   Check EXTEL status                                                     **/
 
        IF   COND((&EXST *NE 'A') *AND (&EXST *NE 'T') *AND  +
             (&EXST *NE 'C') *AND (&EXST *NE 'F'))  THEN(DO) /*  B1  */
             SNDPGMMSG  MSG('EXTEL updates not complete')  +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO    ENDPGM
        ENDDO                                               /*  E1   */
 
/*   Clear file                                                             **/
 
        CLRPFM     EXTELA
 
/*   Maintenance program                                                    **/
 
        CALL       SE3108
 
/*   Check for Database errors trapped by the program                       **/
 
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/************RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&DATA)        * *S01117*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&DATA)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
 
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
