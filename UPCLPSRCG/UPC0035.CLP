/*********************************************************************/
/*OVR    OVRDBF FILE(FROMLIB) TOFILE(QADSPOBJ)                       */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Copy /COPY to specified location')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0035 - Copy /COPYs to specified location                 */
/*                                                                   */
/********Called*by:*UPC2035*******************************************/                   /*CPK016*/
/*       Called by: command CPYCPYSRC                                */                   /*CPK016*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP099             Date 18May05              */
/*       Prev Amend No. CPK018             Date 03Mar04              */
/*                      CPK016             Date 16Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002 *CREATE     Date 16Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP099 - Handle STDCRTPARM for global layer.                */
/*       CPK018 - MidasPlus packaging.  Handle Global layer.         */
/*       CPK016 - Release 5 packaging.  Make command more generic.   */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP002 - Introduction of new utility for BRIDGE             */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&PTFSRC &TOLIB)                                           */ /*CPK018*/
             PGM        PARM(&PTFSRC &TOLIB &LAYER)                                       /*CPK018*/
 
             DCL        VAR(&PTFSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CPK018*/
             DCL        VAR(&ODOSBS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(QTEMP/FROMLIB)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Obtain list of files in 'From Library' */                                              /*CPK016*/
             DLTF       FILE(QTEMP/FROMLIB)                                               /*CPK016*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK016*/
             DSPOBJD    OBJ(&PTFSRC/*ALL) OBJTYPE(*FILE) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FROMLIB)                         /*CPK016*/
 
/* Obtain 'From Library' name from BRIDGE ICD file */
 LOOP:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             CHGVAR     VAR(&ODOSBS) VALUE(%SST(&ODOBNM 3 8))
 
/* Copy for zone layer. */                                                                /*CPK018*/
             IF         COND(&LAYER *EQ '*ZONE') THEN(DO)                                 /*CPK018*/
                IF         COND(&ODOBNM *EQ 'QWINDSRC' *OR &ODOBNM *EQ +
                             'STDCRTPARM' *OR &ODOBNM *EQ 'ZSRSRC' *OR +
                             &ODOSBS *EQ 'CPYSRC') THEN(DO)
 
/************   CPYF       FROMFILE(&PTFSRC/&ODOBNM) +                                 */ /*CPK016*/
/************                TOFILE(&TOLIB/&ODOBNM) FROMMBR(*ALL) +                    */ /*CPK016*/
/************                TOMBR(*FROMMBR) MBROPT(*REPLACE) +                        */ /*CPK016*/
/************                CRTFILE(*YES)                                             */ /*CPK016*/
                   MOVMBR     FILE(&PTFSRC/&ODOBNM) MBR(*ALL) +
                                TOLIB(&TOLIB) LEAVE(*YES)                                 /*CPK016*/
 
                ENDDO
             ENDDO                                                                        /*CPK018*/
 
/* Copy for global layer. */                                                              /*CPK018*/
             IF         COND(&LAYER *EQ '*GLOBAL') THEN(DO)                               /*CPK018*/
/**********     IF         COND(&ODOBNM *EQ 'QWINDSRCG' *OR &ODOSBS *EQ +              */ /*CUP099*/
/**********                  'CPYSRCG') THEN(DO)                            */ /*CPK018*/ /*CUP099*/
                IF         COND(&ODOBNM *EQ 'QWINDSRCG' *OR &ODOSBS *EQ +
                             'CPYSRCG' *OR &ODOBNM *EQ 'STDCRTPARM') +
                             THEN(DO)                                                     /*CUP099*/
                   MOVMBR     FILE(&PTFSRC/&ODOBNM) MBR(*ALL) +
                                TOLIB(&TOLIB) LEAVE(*YES)                                 /*CPK018*/
                ENDDO                                                                     /*CPK018*/
             ENDDO                                                                        /*CPK018*/
 
             GOTO       CMDLBL(LOOP)
 
             GOTO       CMDLBL(END)
 ABNOR:
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0035') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC0035' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
