/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Midas SWIFT term compression and com.')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Swift Direct Link Module                            */
/*                                                                   */
/*       MSC4000 - Swift Direct Link I/c termination                 */
/*                 Terminate Compression & Communication Programs    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CSW017             Date 11Feb99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      120202             Date 17Sep97              */
/*                      CSW009             DATE 12MAR97              */
/*                      CSW008             DATE 14NOV96              */
/*                      CCB001 *CREATE     DATE 01MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSW017 - Midas/SWIFT Meridian interface                     */
/*       120202 - AOMGMER0 parameters have changed                   */
/*       CSW009 - Midas-SWIFT Alliance Automated File Transfer       */
/*       CSW008 - Processing added for SWIFT interface shutdown      */
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MSC4000INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL        VAR(&SDMGME) TYPE(*CHAR) LEN(188)             /*120202*/
             DCL        VAR(&SDMGME) TYPE(*CHAR) LEN(800)             /*120202*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
/*/COPY WNCPYSRC,MSC4000001                                          */
 
 /*  Global monitor trap */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,MSC4000MPS                                          */
 
/*  Access PF/SDMGMEPD to determine                        */
/*  whether communications are through the SWIFT interface */
/*  or through the Merva interface                         */
 
             CHGVAR     VAR(&RTCD) VALUE('*MSG   ')
 
             CALL       PGM(AOMGMER0) PARM(&RTCD &OPTN &SDMGME)
 
/*  Database error handling                                        */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
                SNDPGMMSG  MSG('Error on access to ICD file +
                             AOMGMEPD') TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If communications are via the CASmf, shutdown all CASmf comms jobs  *CSW008*/
/* and terminate.                                                      *CSW008*/
             IF         COND(%SST(&SDMGME 17 3) *EQ 'CAS') THEN(DO)   /*CSW008*/
             WRKCASIF   OPERATION(*SHUTDOWN) L_MAPID(*ALL) +
                          TYPE(*SYNCH)                                /*CSW008*/
             GOTO       CMDLBL(END)                                   /*CSW008*/
             ENDDO                                                    /*CSW008*/
                                                                      /*CSW008*/
/* If communications are via Meridian, shutdown all Meridian comms jobs*CSW017*/
/* and terminate.                                                      *CSW017*/
             IF         COND(%SST(&SDMGME 17 4) *EQ 'MERI') THEN(DO)  /*CSW017*/
             WRKMSMIF   OPERATION(*SHUTDOWN) MCID(*ALL) +
                          TYPE(*SYNCH)                                /*CSW017*/
             GOTO       CMDLBL(END)                                   /*CSW017*/
             ENDDO                                                    /*CSW017*/
                                                                      /*CSW017*/
/*/COPY WNCPYSRC,MSC4000002                                          */
/* If communications are via the Midas-SWIFT Alliance Automated File   *CSW009*/
/* Transfer interface terminate communications jobs using CMD/WRKMAIF  *CSW009*/
             IF         COND(%SST(&SDMGME 17 4) *EQ 'AFT ') THEN(DO)  /*CSW009*/
             WRKMAIF    OPERATION(*SHUTDOWN)                          /*CSW009*/
             GOTO       CMDLBL(END)                                   /*CSW009*/
             ENDDO                                                    /*CSW009*/
 
/*/COPY WNCPYSRC,MSC4000003                                          */
/* Check whether communications are through the Merva interface */
/* rather than the SWIFT interface                              */
 
             IF         COND(%SST(&SDMGME 17 4) *EQ 'APPC') THEN(DO)
                CALL       PGM(MSC6002)
 
/* Clear down all the Merva API log files */
 
                CLRPFM     FILE(MSLOGIPD) MBR(DIAG)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(MSLOGIPD) MBR(PLOG)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(MSLOGOPD) MBR(PLOG)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(MSLOGOPD) MBR(DIAG)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(MSLOGTPD) MBR(PLOG)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(MSLOGTPD) MBR(DIAG)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             ELSE       CMD(CALL PGM(MSC4002))
 
/*/COPY WNCPYSRC,MSC4000MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MSC4000ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDMSG     MSG('MSC4000 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
/*/COPY WNCPYSRC,MSC4000END                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
