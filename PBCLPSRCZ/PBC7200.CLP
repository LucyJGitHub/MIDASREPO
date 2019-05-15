/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB TOF account closing setup')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       PBC7200  - Account Closing - Program Setup for CPB004       */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPB004  *CREATE    Date 11Jul02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB004 - Initialise new 'To be transferred to TOF' flag in  */
/*                SDACODPD based on account type is retail.          */
/*                Blank protfolio reference for all non retail a/cs. */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &MODE)
 
/* Declare variables */
              DCL       VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
              DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)
              DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7)
              DCL       VAR(&MODE) TYPE(*CHAR) LEN(1)
 
              MONMSG    MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Create LDA if not present */
              CHKOBJ    OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
              MONMSG    MSGID(CPF9801) EXEC(DO)
                CRTDTAARA DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) AUT(*EXCLUDE)
              ENDDO
 
             CHGJOB SWS(00000000)
 
/* If not amend or insert Mode (1=Inser; 2=Amend; 3=Delete) */
             IF         COND((&MODE *NE '1') *AND (&MODE *NE '2')) THEN(GOTO +
                          CMDLBL(END))
 
/* Call program */
             CALL       PGM(PB7200) PARM(&RTCD &MODE)
 
              IF        COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO      CMDLBL(ABNOR)
              ENDDO
 
              GOTO      CMDLBL(END)
 
/* Error processing */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             MONMSG     MSGID(CPF0000)
 
             ROLLBACK
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&RTCD) VALUE('*ERROR')
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
