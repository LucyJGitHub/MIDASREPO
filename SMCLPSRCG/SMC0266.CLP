/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Rebuild logical file member')                */
/*XBIA   OVRDBF FILE(FILEMBR) TOFILE(QAFDMBR)                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0266 - Rebuild logical file member                       */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CPK026             Date 08Dec06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK025             Date 24Aug06              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK026 - MidasPlus 1.3 packaging.  CHKOBJ in case member    */
/*                doesn't exist.                                     */
/*       CPK025 - MidasPlus 1.3 packaging.  Change to /COPY          */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETURN)
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LASTFILE) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCLF       FILE(FILEMBR)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
READNEXT:
RETRY:
             CHGVAR     VAR(&LASTFILE) VALUE(&MBFILE)
 
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/* Check that file name does not match previous read */
             IF         COND(&MBFILE *EQ &LASTFILE) THEN(DO)
                GOTO       CMDLBL(READNEXT)
             ENDDO
 
/* Check that logical exists in new system. */
             CHKOBJ     OBJ(&MBFILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                GOTO       CMDLBL(READNEXT)
             ENDDO
 
/* Check that logical - is not multi-membered                        */
/*                    - is not join logical                          */
/*                    - No. of Record Formats is greater than 1      */
/*                    - No. of Record Formats is not equal to        */
/*                      Number Of Members Accessed By Logical File   */
             IF         COND(&MBNOMB *EQ 1 *AND &MBJOIN *EQ 'N' *AND +
                          &MBNSCM *GT 1 *AND &MBNSCM *NE &MBNOFM) +
                          THEN(DO)
/* Do not attempt to remove if the file is an SQL view (field from */
/* FILEMBR has text of 'reserved').                                */
                IF         COND(&MBRES4 *NE 'V') THEN(DO)
                   RMVM       FILE(&MBFILE) MBR(&MBNAME)
                   MONMSG     MSGID(CPF0000)                                              /*CPK026*/
                   ADDLFM     FILE(&MBFILE) MBR(&MBNAME)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Error handling brought in through /COPY */
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                RTVMSG    MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(SMC0266) +
                          MSG(&MESSAGE)
/**COPY*SMCPYSRCG,C_SMERRA*                                          */ /*             */ /*CPK025*/
/*/COPY UPCPYSRCG,C_UPERRA                                           */                   /*CPK025*/
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
