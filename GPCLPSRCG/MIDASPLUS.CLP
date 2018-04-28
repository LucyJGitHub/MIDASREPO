/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GP MidasPlus initial program')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       MIDASPLUS - MidasPlus Initial Program                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG12061            Date 20Sep06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 240279             Date 30Jun06              */
/*                      BUG10066           Date 24Jan06              */
/*                      TDA024             Date 23Mar04              */
/*                      CAAA02             Date 17Oct03              */
/*                      XXXXXX             Date XXmmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG12061 - Addition of Consumer Banking message file.        */
/*                 Pass the user multilanguage code to GPC000200     */
/*       240279 - Create data area DLSDS.                            */
/*       BUG10066-Display Message Error (Recompile)                  */
/*       TDA024 - Database error occurs when accessing account       */
/*                details.  This is due to the incorrect length of   */
/*                the created EMSDS data area.  Changed its length   */
/*                from 161 to 167.                                   */
/*       CAAA02 - Initial Program for Midas Plus Global Zone         */
/*                                                                   */
/*********************************************************************/
             PGM
 
/****COPY*MLCPYSRC,MLCOVRDCL                                        */                    /*CPK022*/
/*/COPY GPCPYSRCG,MLCOVRDCL                                         */                    /*CPK022*/
 
/*/COPY WNCPYSRC,MLCOVRRC1                                         */
 
/*/COPY WNCPYSRC,MLCOVRRC2                                         */
 
             DCL        VAR(&RCVVAR) TYPE(*CHAR) LEN(25)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('PRDR0100')
             DCL        VAR(&PRDINF) TYPE(*CHAR) LEN(27) +
                          VALUE('*OPSYS *CUR  0000*CODE    ')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
 
             RTVJOBA    USER(&USRID)
 
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')
             MONMSG     MSGID(CPF1023)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
             MONMSG     MSGID(CPF1023)
 
/****COPY*MLCPYSRC,MLCOVROVR                                         */                   /*CPK022*/
/*/COPY GPCPYSRCG,MLCOVROVR                                         */                    /*CPK022*/
 
/*/COPY WNCPYSRC,MLCOVRRC3                                         */
 
/*/COPY WNCPYSRC,MLCOVRRC4                                         */
 
/*    Determine operating system level                             */
 
             CALL       PGM(QSZRTVPR) PARM(&RCVVAR X'00000019' +
                          &FORMAT &PRDINF X'00000000')
 
             CHGVAR     VAR(&OSLVL) VALUE(%SST(&RCVVAR 20 6))
             CHGVAR     VAR(&OSLVL2) VALUE(%SST(&OSLVL 1 2) *CAT +
                          'DFT')
 
/* GPAFT1PD */
 
             CHGVAR     VAR(&AFTMBR) VALUE('          ')
             CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL)
             CHKOBJ     OBJ(GPAFT1PD) OBJTYPE(*FILE) MBR(&OSLVL)
             MONMSG     MSGID(CPF9815) EXEC(DO)
                CHGVAR     VAR(&AFTMBR) VALUE('          ')
                CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL2)
                CHKOBJ     OBJ(GPAFT1PD) OBJTYPE(*FILE) MBR(&OSLVL2)
                MONMSG     MSGID(CPF9815) EXEC(DO)
                   CHGVAR     VAR(&AFTMBR) VALUE('          ')
                   CHGVAR     VAR(&AFTMBR) VALUE(*FIRST)
                ENDDO
             ENDDO
 
             OVRDBF     FILE(GPAFT1PD) MBR(&AFTMBR)
 
/* GPAFT2PD */
 
             CHGVAR     VAR(&AFTMBR) VALUE('          ')
             CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL)
             CHKOBJ     OBJ(GPAFT2PD) OBJTYPE(*FILE) MBR(&OSLVL)
             MONMSG     MSGID(CPF9815) EXEC(DO)
                CHGVAR     VAR(&AFTMBR) VALUE('          ')
                CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL2)
                CHKOBJ     OBJ(GPAFT2PD) OBJTYPE(*FILE) MBR(&OSLVL2)
                MONMSG     MSGID(CPF9815) EXEC(DO)
                   CHGVAR     VAR(&AFTMBR) VALUE('          ')
                   CHGVAR     VAR(&AFTMBR) VALUE(*FIRST)
                ENDDO
             ENDDO
 
             OVRDBF     FILE(GPAFT2PD) MBR(&AFTMBR)
 
/* GPAFT3PD */
 
             CHGVAR     VAR(&AFTMBR) VALUE('          ')
             CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL)
             CHKOBJ     OBJ(GPAFT3PD) OBJTYPE(*FILE) MBR(&OSLVL)
             MONMSG     MSGID(CPF9815) EXEC(DO)
                CHGVAR     VAR(&AFTMBR) VALUE('          ')
                CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL2)
                CHKOBJ     OBJ(GPAFT3PD) OBJTYPE(*FILE) MBR(&OSLVL2)
                MONMSG     MSGID(CPF9815) EXEC(DO)
                   CHGVAR     VAR(&AFTMBR) VALUE('          ')
                   CHGVAR     VAR(&AFTMBR) VALUE(*FIRST)
                ENDDO
             ENDDO
 
             OVRDBF     FILE(GPAFT3PD) MBR(&AFTMBR)
 
/* Create the data area ZMITEM in QTEMP */
 
             CRTDTAARA  DTAARA(QTEMP/ZMITEM) TYPE(*CHAR) LEN(10) +
                          TEXT('Midas SF Menu group/item code')
             MONMSG     MSGID(CPF1023)
 
/* Create the data area ZIG in QTEMP */
 
             CRTDTAARA  DTAARA(QTEMP/ZIG) TYPE(*CHAR) LEN(1) VALUE(' +
                          ') TEXT('Midas SF Show/remove +
                          menu group code')
             MONMSG     MSGID(CPF1023)
 
/* Create data area for use in Treasury Management enquiries */                           /*240279*/
                                                                                          /*240279*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167) +
                          TEXT('Midas TM Treasury +
                          management enquiries')                                          /*240279*/
             MONMSG     MSGID(CPF1023)                                                    /*240279*/
                                                                                          /*240279*/
/* Create data area for use in Exposure Management enquiries */
 
/**********  CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(161) +
                          TEXT('Midas EM Exposure +
                          Management enquiries') */                                       /*TDA024*/
             CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(167) +
                          TEXT('Midas EM Exposure +
                          Management enquiries')                                          /*TDA024*/
             MONMSG     MSGID(CPF1023)
 
/* Create a temporary file for directory ID and address processing */
 
             DSPDIRE    USER(&USRID) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/TEMP)
             MONMSG     MSGID(CPF9006)
 
/**********  CALL       PGM(GPC000200) */                                                /*BG12061*/
             CALL       PGM(GPC000200) PARM(&MULT)                                       /*BG12061*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 45)) RTNVAR(&ERRDTA)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                             TOPGMQ(*EXT)
             ENDDO
 
 SOFF:
                SIGNOFF    LOG(*NOLIST)
 
ABNOR:
 
             SNDPGMMSG  MSG('Midas initial program terminated +
                          abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
             RTVMSG     MSGID(SCM0072) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CALL       PGM(SCC0010) PARM('MIDASPLUS' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Abnormal termination. */
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
