/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AGDL Manual Adjustments.')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - AGDL Reporting Module                               */
/*                                                                   */
/*       ERCAG10 - AGDL Manual Adjustments.                          */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX010  *CREATE    Date 26Jun98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX010 - AGDL reporting statistiques sur les depôts garantis*/
/*                                                                   */
/*********************************************************************/
              PGM
 
/* Declare variables */
              DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                           Finastra International Limited +
                           2005')
              DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)
 
              MONMSG    MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Create LDA if not present */
              CHKOBJ    OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
              MONMSG    MSGID(CPF9801) EXEC(DO)
                CRTDTAARA DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) AUT(*EXCLUDE)
              ENDDO
 
/* Reset external switches */
              CHGJOB    SWS(00000000)
 
/* Call program */
              CALL      PGM(ERAG10)
 
              IF        COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO      CMDLBL(ABNOR)
              ENDDO
 
              GOTO      CMDLBL(END)
 
/* Error processing */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
