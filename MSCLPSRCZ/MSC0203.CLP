/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Comms/compression pgm submission')           */
/********************************************************************/
/*                                                                  */
/*     Midas S.W.I.F.T. DIRECT LINK                                 */
/*                                                                  */
/*     MSC0203 - COMMUNICATIONS/COMPRESSION PROGRAM SUBMISSION      */
/*               CONTROL                                            */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*     Last Amend No CSW017            Date 11Feb99                 */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     PREV AMEND.NO CSW009            DATE 12MAR97                 */
/*                   CSW008            DATE 14NOV96                 */
/*                   S01431            DATE 23SEP93                 */
/*                   E38960            DATE 23/04/92                */
/*                   S01192            DATE 30/01/89                */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*     CSW017 - Midas/SWIFT Meridian interface                      */
/*     CSW009 - Midas-SWIFT Alliance Automated File Transfer        */
/*     CSW008 - Processing added for SWIFT interface startup        */
/*     S01431 - Processing added for a Merva link                   */
/*     E38960 - USE SDMGMEPD NOT SDMSDLPD                           */
/*     S01192 - NEW PROGRAM FOR 2780 LINK                           */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
       /*    DCLF       FILE(SDMSDLL1)       E38960*/
             DCLF       FILE(SDMGMEL1) /* E38960 */
/*/COPY WNCPYSRC,MSC0203001                                          */
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                  */
/* Retrieve protocol parameter from ICD                             */
/*                                                                  */
             RCVF
/*/COPY WNCPYSRC,MSC0203002                                          */
/*                                                                  */
/* For 3270 Link, submit communications program                     */
/*                                                                  */
/*********** IF         COND(&BSKHST *EQ '3270') THEN(CALL +        /*S01117*/
/*           IF         COND(&BSPRUS *EQ '3270') THEN(CALL +
                          PGM(MSC4001))           E38960*/
             IF         COND(&ENPRUS *EQ '3270') THEN(CALL +
                          PGM(MSC4001)) /* E38960 */
/*                                                                  */
/* For 2780 Link, set MSSTAT to communications program active       */
/*  to prevent misleading error messages being issued               */
/*                                                                  */
/*********** IF         COND(&BSKHST *EQ '2780') THEN(CHGDTAARA +   /*S01117*/
/*           IF         COND(&BSPRUS *EQ '2780') THEN(CHGDTAARA +
                          DTAARA(MSSTAT (23 1)) VALUE(Y))    E38960*/
             IF         COND(&ENPRUS *EQ '2780') THEN(CHGDTAARA +
                          DTAARA(MSSTAT (23 1)) VALUE(Y)) /* E38960 */
/*                                                                  */
                                                                      /*S01431*/
/* For a Merva link,                                                * /*S01431*/
/* submit Merva communications programs                             * /*S01431*/
             IF         COND(&ENPRUS *EQ 'APPC') THEN(CALL +
                          PGM(MSC6001))                               /*S01431*/
                                                                      /*S01431*/
/* For a CASmf link,                                                   *CSW008*/
/* issue startup/shutdown command WRKCASIF                             *CSW008*/
             IF         COND(&ENPRUS *EQ 'CAS') THEN(WRKCASIF +
                          OPERATION(*STARTUP) L_MAPID(*ALL) +
                          MODE(*AUTO))                                /*CSW008*/
                                                                      /*CSW008*/
/*/COPY WNCPYSRC,MSC0203003                                          */
/* For a Meridian link                                                 *CSW017*/
/* issue startup/shutdown command WRKMSMIF                             *CSW017*/
             IF         COND(&ENPRUS *EQ 'MERI') THEN(WRKMSMIF +
                          OPERATION(*STARTUP) MCID(*ALL) +
                          MODE(*AUTO))                                /*CSW017*/
                                                                      /*CSW017*/
/*/COPY WNCPYSRC,MSC0203005                                          */
/* For Midas-SWIFT Alliance Automated File Transfer intrface:          *CSW009*/
/* issue startup command WRKMAIF                                       *CSW009*/
             IF         COND(&ENPRUS *EQ 'AFT ') THEN(WRKMAIF +
                          OPERATION(*STARTUP))                        /*CSW009*/
/*/COPY WNCPYSRC,MSC0203004                                          */
                                                                      /*CSW009*/
             GOTO       CMDLBL(END)
/*                                                                  */
 ABNOR:      SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                          Communications submission ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
