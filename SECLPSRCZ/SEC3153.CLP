/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Cust/Broker Default Charges Maint')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*     SEC3153 - CUSTOMER/BROKER DEFAULT CHARGES MAINTENANCE        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*         LAST AMEND NO. S01117             DATE  11JAN91          */
/*                                                                  */
/*---------------------------------------------------------------------
/*                                                                  */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(44) /* for  +     * *S01117*/
/************             database errors */                          /*S01117*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50) /* for  +
                          database errors */                          /*S01117*/
             CHGJOB     SWS(00000000)
             CALL       PGM(SE3153)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             ROLLBACK
             SNDPGMMSG  MSG('Transaction failed. Re-input  necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* DATABASE ERROR */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)           * *S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)            /*S01117*/
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOMSGQ(MRUNQ MOPERQ) TOPGMQ(*EXT)
             ENDDO
/*ENDPGM:****ENDPGM      * ENDPGM TAG *                              * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
            ENDPGM                                                    /*S01117*/
