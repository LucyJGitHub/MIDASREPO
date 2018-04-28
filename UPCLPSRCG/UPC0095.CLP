/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Add text to deliverables list')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0095 - Add text to deliverables list                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. BUG27989           Date 08Aug10              */
/*       Prev Amend No. BUG27832A          Date 07Jul10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK018             Date 16Mar04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 17Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CUP003 *CREATE     Date 29Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG27989 - HATS should run with/without LDAP                */
/*       BUG27832A - New SQLDTAARA member type.                      */
/*       CPK018 - MidasPlus packaging.  New object types.            */
/*       CPK015 - 4.01 packaging.  Check modules/pgms.               */
/*       CUP003 - New utility for maintaining deliverables list.     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETURN)
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(UPDLVCLK)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&RETURN) VALUE(' ')
             CHGVAR     VAR(&USTS) VALUE('C')
 
READNEXT:
             IF         COND(&AUMBNM *NE ' ') THEN(DO)
/*/COPY UPCPYSRCG,C_UP0020A                                          */
             ENDDO
 
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&AUMBTP *NE 'DOC') THEN(DO)
 
                CHGVAR     VAR(&OBJTYPE) VALUE(' ')
/* Work out object type */
                IF         COND(&AUMBTP *EQ 'RPG' +
                            *OR &AUMBTP *EQ 'CLP' +
                            *OR &AUMBTP *EQ 'PGM' +
                            *OR &AUMBTP *EQ 'EXE') +
                             THEN(DO)
                   CHGVAR     VAR(&OBJTYPE) VALUE('*PGM')
                ENDDO
                IF         COND(&AUMBTP *EQ 'RPGLE' +
                            *OR &AUMBTP *EQ 'CLLE' +
                            *OR &AUMBTP *EQ 'CLE') +
                             THEN(DO)
                   CHGVAR     VAR(&OBJTYPE) VALUE('*MODULE')
/* If module is not found try program. */                                                 /*CPK015*/
                   CHKOBJ     OBJ(&AUMBNM) OBJTYPE(*MODULE)                               /*CPK015*/
                   MONMSG     MSGID(CPF9801) EXEC(DO)                                     /*CPK015*/
                      CHGVAR     VAR(&OBJTYPE) VALUE('*PGM')                              /*CPK015*/
                   ENDDO                                                                  /*CPK015*/
                ENDDO
/**********     IF         COND(&AUMBTP *EQ 'DSPF' +                                   */ /*CPK018*/
/**********                 *OR &AUMBTP *EQ 'PRTF' +                                   */ /*CPK018*/
/**********                 *OR &AUMBTP *EQ 'PF' +                                     */ /*CPK018*/
/**********                 *OR &AUMBTP *EQ 'LF' +                                     */ /*CPK018*/
/**********                 *OR &AUMBTP *EQ 'DATA') +                                  */ /*CPK018*/
                IF         COND(&AUMBTP *EQ 'DSPF' +
                            *OR &AUMBTP *EQ 'PRTF' +
                            *OR &AUMBTP *EQ 'PF' +
                            *OR &AUMBTP *EQ 'LF' +
                            *OR &AUMBTP *EQ 'SQLVIEW' +
                            *OR &AUMBTP *EQ 'SQLTBL' +
                            *OR &AUMBTP *EQ 'DATA') +
                             THEN(DO)                                                     /*CPK018*/
                   CHGVAR     VAR(&OBJTYPE) VALUE('*FILE')
                ENDDO
/************   IF         COND(&AUMBTP *EQ 'SRVPGM' +                                 */ /*CPK015*/
/************               *OR &AUMBTP *EQ 'CMD' +                                    */ /*CPK015*/
/************               *OR &AUMBTP *EQ 'PNLSRC' +                                 */ /*CPK015*/
/************               *OR &AUMBTP *EQ 'PNLGRP' +                                 */ /*CPK015*/
/************               *OR &AUMBTP *EQ 'DTAARA') +                                */ /*CPK015*/
/************                THEN(DO)                                                  */ /*CPK015*/
                IF         COND(&AUMBTP *EQ 'SRVPGM' +
                            *OR &AUMBTP *EQ 'CMD' +
                            *OR &AUMBTP *EQ 'PNLGRP' +
                            *OR &AUMBTP *EQ 'DTAARA') +
                             THEN(DO)                                                     /*CPK015*/
                   CHGVAR     VAR(&OBJTYPE) VALUE('*' *TCAT &AUMBTP)
                ENDDO
                IF         COND(&AUMBTP *EQ 'SQLDTAARA') THEN(DO)                      /*BUG27832A*/
                   CHGVAR     VAR(&OBJTYPE) VALUE('*DTAARA')                           /*BUG27832A*/
                ENDDO                                                                  /*BUG27832A*/
                IF         COND(&AUMBTP *EQ 'MSGF') +
                             THEN(DO)
                   CHGVAR     VAR(&OBJTYPE) VALUE('*MSGF')
                ENDDO
                IF         COND(&AUMBTP *EQ 'VLDL     ') THEN(DO)                       /*BUG27989*/
                   CHGVAR     VAR(&OBJTYPE) VALUE('*VLDL')                              /*BUG27989*/
                ENDDO                                                                   /*BUG27989*/
 
                IF         COND(&OBJTYPE *EQ ' ') THEN(DO)
                   CHGVAR     VAR(&USTS) VALUE('F')
                   GOTO       CMDLBL(READNEXT)
                ENDDO
                RTVOBJD    OBJ(&AUMBNM) OBJTYPE(&OBJTYPE) TEXT(&TEXT)
                MONMSG     MSGID(CPF9801 CPF9811 CPF9812) EXEC(DO)
                   CHGVAR     VAR(&USTS) VALUE('F')
                   GOTO       CMDLBL(READNEXT)
                ENDDO
/* Call to UP0020 to update deliverables list */
/*/COPY UPCPYSRCG,C_UP0020B                                          */
 
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGVAR     VAR(&RETURN) VALUE('F')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
