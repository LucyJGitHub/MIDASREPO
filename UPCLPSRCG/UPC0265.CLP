/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Rebuild multimember logical files')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0265 - Rebuild Multimember Files                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK022             Date 29Jul05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 19Jun02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 27Dec01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 06Aug98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK022 - Should not use zone /COPYs.                        */
/*       CPK015 - 4.01 packaging.  Improve error handling.           */
/*       CPK014 - If FILEMULMBR not present then ignore rather than  */
/*                crash.                                             */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PTFUPG &RETURN)
 
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
RETRY:
READNEXT:
/* Check that file exists; if not it will go to END. */
             CHKOBJ     OBJ(&PTFUPG/FILEMULMBR) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CPK014*/
                GOTO       CMDLBL(END)                                                    /*CPK014*/
             ENDDO                                                                        /*CPK014*/
 
/************CALL       PGM(UP0265)                                                    */ /*CPK015*/
             CALL       PGM(UP0265) PARM(&RETURN)                                         /*CPK015*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Error handling brought in through /COPY */
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                RTVMSG    MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(UPC0265) +
                          MSG(&MESSAGE)
/***COPY*UPCPYSRC,C_UPERRA                                            */                  /*CPK022*/
/*/COPY GPCPYSRCG,C_UPERRA                                           */                   /*CPK022*/
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
