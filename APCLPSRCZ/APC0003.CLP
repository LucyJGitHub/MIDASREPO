/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AP API transactions repaired/completed today')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APC0003 - Transactions Repaired/Completed Today             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSD092             Date 01May13              */
/*                      CSD093             Date 01Apr13              */
/*                      CER059             Date 19Jul10              */
/*                      CER034A            Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG13549           Date 14Mar07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CAP185             Date 21Apr06              */
/*                      CAP183             Date 05Jan06              */
/*                      CAS009             Date 04May04              */
/*                      CAP078             Date 31Oct02              */
/*                      CAP182             Date 14Mar03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAP055             Date 13Mar02              */
/*                      CAP069             Date 28Mar02              */
/*                      CAP072             Date 28Mar02              */
/*                      CAP071             Date 22Mar02              */
/*                      CAP068             Date 22Mar02              */
/*                      CAP070             Date 11Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CAP060             Date 05May01              */
/*                      CAP057             Date 05May01              */
/*                      CAP038             Date 05May01              */
/*                      CAP058             Date 05May01              */
/*                      CAP059             Date 05May01              */
/*                      CAP042             Date 08Jan01              */
/*                      CAP140             Date 17Oct00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CAP039             Date 14Jul00              */
/*                      CAP137             Date 07Feb00              */
/*                      CAP136             Date 15Nov99              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CAP035             Date 07Jul99              */
/*                      CAP034             Date 07Jul99              */
/*                      CAP031             Date 07Jul99              */
/*                      CAP033             Date 26Apr99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP004             Date 19Feb98              */
/*                      CAP002  *CREATE    Date 19Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD092 - Account Review                                     */
/*       CSD093 - Document Management                                */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER034A - German Features - New Fields and Enquiries        */
/*       BUG13549 - Reverse MQ Series Interface Changes. Create      */
/*                  another CL for MQ instead.                       */
/*       CAP185 - MQ Series Interface                                */
/*       CAP183 - Conversion of Market Prices Input into modular     */
/*                structure to use APIs                              */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CAP078 - Lending API enhancements - Fee input               */
/*       CAP182 - Automatic Settlement of Trades                     */
/*              - Conversion of SE Trade Settlement Input maintence  */
/*                function to modular structure to use as APIs.      */
/*       CAP055 - APIs for FRA/IRS Caps/Collars/Floors               */
/*       CAP069 - Conversion of LE inputs into modular structure to  */
/*                use as APIs. Risk Participants.                    */
/*       CAP072 - Conversion of LE inputs into modular structure to  */
/*                use as APIs. Fee Settlement and Adjustment input   */
/*       CAP071 - Conversion of LE inputs into modular structure to  */
/*                use as APIs. Facility Amendment.                   */
/*       CAP068 - Conversion of LE inputs into modular structure to  */
/*                use as APIs. Funding Participants.                 */
/*       CAP070 - Conversion of LE inputs into modular structure to  */
/*                use as APIs.                                       */
/*       CAP060 - Security Prices Full API                           */
/*       CAP057 - Spot Rates Full API                                */
/*       CAP038 - Base Rates Full API                                */
/*       CAP058 - Money Market Interest Rates API                    */
/*       CAP059 - Forward Rates API                                  */
/*       CAP042 - Conversion of Internal Funding Deal inputs into    */
/*                modular structure to use as APIs.                  */
/*       CAP140 - Conversion of SE Security Diary Event inputs into  */
/*                modular structure to use as APIs.                  */
/*       CAP039 - Add processing for SD SECURITY CUSTOMER DETAILS    */
/*       CAP137 - Conversion of SE Security inputs into modular      */
/*                structure to use as APIs.                          */
/*       CAP136 - Conversion of FT Incoming Payment inputs into      */
/*                modular structure to use as APIs.                  */
/*       CAP035 - Add processing for G/L ACCOUNTS MAINTENANCE        */
/*       CAP034 - Add processing for SD CUSTOMERS DETAILS            */
/*       CAP031 - Add processing for FT Outgoing Payments            */
/*       CAP033 - Conversion of PM inputs into modular structure to  */
/*                use as APIs.                                       */
/*       CAP004 - APIs phase 3                                       */
/*       CAP002 - Conversion of transaction inputs into modular      */
/*                structure to use as APIs.                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
                                                                             /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                    /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                        /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                        /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                        /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&CAP185) TYPE(*CHAR) LEN(1)                      /*CAP185*/ /*BUG13549*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*   Set off switches  */
/**/
             CHGJOB     SWS(00000000)
/**/
/*   Retrieve job information  */
/**/
             RTVJOBA       JOB(&JOB)
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 1 1))
/**/                                                                         /*CAP185*/ /*BUG13549*/
/* Check if CAP185 is enabled. */                                            /*CAP185*/ /*BUG13549*/
/**/                                                                         /*CAP185*/ /*BUG13549*/
/*         CHGVAR     VAR(&RTCD) VALUE('       ')                            /*CAP185*/ /*BUG13549*/
/*         CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                            /*CAP185*/ /*BUG13549*/
/*         CHGVAR     VAR(&SARD) VALUE('CAP185')                             /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
/*         CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)          /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
/*         CHGVAR     VAR(&CAP185) VALUE('N')                                /*CAP185*/ /*BUG13549*/
/*         IF         COND(&RTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAP185) VALUE('Y'))                   /*CAP185*/ /*BUG13549*/
/**/
/*   Check if another job is active and wait until it has ended */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 /* CHECK:******CRTDTAARA**DTAARA(&TOLIB/APC0003) TYPE(*CHAR) LEN(1)  /*CAP004*/
 CHECK:      CRTDTAARA  DTAARA(&TOLIB/APC0002) TYPE(*CHAR) LEN(1)     /*CAP004*/
             MONMSG     MSGID(CPF1023) EXEC(DO)
             DLYJOB     DLY(30)
             GOTO       CMDLBL(CHECK)
             ENDDO
/**/
/*   Clear extract file */
/**/
/*           IF         COND(&CAP185 *NE 'Y') THEN(DO)                       /*CAP185*/ /*BUG13549*/
                                                                             /*CAP185*/ /*BUG13549*/
             CLRPFM     FILE(APINVLPD)
/**/
/*   Run extract to set up invalid transaction file */
/**/
             OVRDBF     FILE(MMIDEAMP) TOFILE(MMIDEAMPD) SHARE(*NO)
             OVRDBF     FILE(MMILDNIP) TOFILE(MMILDNIPD) SHARE(*NO)
             OVRDBF     FILE(MMINASPP) TOFILE(MMINASPPD) SHARE(*NO)
             OVRDBF     FILE(MMINASSP) TOFILE(MMINASSPD) SHARE(*NO)
             OVRDBF     FILE(FXIFXDLP) TOFILE(FXIFXDLPD) SHARE(*NO)
             OVRDBF     FILE(IRISIRSP) TOFILE(IRISIRSPD) SHARE(*NO)   /*CAP004*/
             OVRDBF     FILE(IRICIRSP) TOFILE(IRICIRSPD) SHARE(*NO)   /*CAP004*/
             OVRDBF     FILE(SEIDPMVP) TOFILE(SEIDPMVPD) SHARE(*NO)   /*CAP004*/
             OVRDBF     FILE(SEITRADP) TOFILE(SEITRADPD) SHARE(*NO)   /*CAP004*/
             OVRDBF     FILE(ABIINTCP) TOFILE(ABIINTCPD) SHARE(*NO)   /*CAP004*/
             OVRDBF     FILE(FFIEXTRP) TOFILE(FFIEXTRPD) SHARE(*NO)   /*CAP004*/
             OVRDBF     FILE(FFIOTCCP) TOFILE(FFIOTCCPD) SHARE(*NO)   /*CAP004*/
             OVRDBF     FILE(PMIPFDMP) TOFILE(PMIPFDMPD) SHARE(*NO)   /*CAP033*/
             OVRDBF     FILE(FTIOPAYP) TOFILE(FTIOPAYPD) SHARE(*NO)   /*CAP031*/
             OVRDBF     FILE(SDICUSDP) TOFILE(SDICUSDPD) SHARE(*NO)   /*CAP034*/
             OVRDBF     FILE(GLIAMADP) TOFILE(GLIAMADPD) SHARE(*NO)   /*CAP035*/
             OVRDBF     FILE(FTIIPAYP) TOFILE(FTIIPAYPD) SHARE(*NO)   /*CAP136*/
             OVRDBF     FILE(SEISECSP) TOFILE(SEISECSPD) SHARE(*NO)   /*CAP137*/
             OVRDBF     FILE(SDISECDP) TOFILE(SDISECDPD) SHARE(*NO)   /*CAP039*/
             OVRDBF     FILE(SEISEDEP) TOFILE(SEISEDEPD) SHARE(*NO)                       /*CAP140*/
             OVRDBF     FILE(FDIFWRTP) TOFILE(FDIFWRTPD) SHARE(*NO)                       /*CAP059*/
             OVRDBF     FILE(FDIINTRP) TOFILE(FDIINTRPD) SHARE(*NO)                       /*CAP058*/
             OVRDBF     FILE(SDIBSRTP) TOFILE(SDIBSRTPD) SHARE(*NO)                       /*CAP038*/
             OVRDBF     FILE(SDISPTRP) TOFILE(SDISPTRPD) SHARE(*NO)                       /*CAP057*/
             OVRDBF     FILE(SEIPRCSP) TOFILE(SEIPRCSPD) SHARE(*NO)                       /*CAP060*/
             OVRDBF     FILE(ABFUNDIP) TOFILE(ABIFUNDPD) SHARE(*NO)                       /*CAP042*/
             OVRDBF     FILE(LEIASGNP) TOFILE(LEIASGNPD) SHARE(*NO)                       /*CAP070*/
             OVRDBF     FILE(LEIRPRTP) TOFILE(LEIRPRTPD) SHARE(*NO)                       /*CAP070*/
             OVRDBF     FILE(LEIFPRTP) TOFILE(LEIFPRTPD) SHARE(*NO)                       /*CAP068*/
             OVRDBF     FILE(LEIRPRTP) TOFILE(LEIRPRTPD) SHARE(*NO)                       /*CAP069*/
             OVRDBF     FILE(LEIFAMDP) TOFILE(LEIFAMDPD) SHARE(*NO)                       /*CAP071*/
             OVRDBF     FILE(LEIFEADP) TOFILE(LEIFEADPD) SHARE(*NO)                       /*CAP072*/
             OVRDBF     FILE(LEIFESTP) TOFILE(LEIFESTPD) SHARE(*NO)                       /*CAP072*/
             OVRDBF     FILE(LEIFACP)  TOFILE(LEIFACPD)  SHARE(*NO)                       /*CSC011*/
             OVRDBF     FILE(LEILAMP)  TOFILE(LEILAMPD)  SHARE(*NO)                       /*CSC011*/
             OVRDBF     FILE(LEILONP)  TOFILE(LEILONPD)  SHARE(*NO)                       /*CSC011*/
             OVRDBF     FILE(LEIROLP)  TOFILE(LEIROLPD)  SHARE(*NO)                       /*CSC011*/
             OVRDBF     FILE(LEIMRPP)  TOFILE(LEIMRPPD)  SHARE(*NO)                       /*CSC011*/
             OVRDBF     FILE(LEIFEEP)  TOFILE(LEIFEED)   SHARE(*NO)                       /*CSC011*/
             OVRDBF     FILE(IRICACFP) TOFILE(IRICACFPD) SHARE(*NO)                       /*CAP055*/
             OVRDBF     FILE(SEITRSMP) TOFILE(SEITRSMPD) SHARE(*NO)                       /*CAP182*/
             OVRDBF     FILE(LEIFEEMP) TOFILE(LEIFEEMPD) SHARE(*NO)                       /*CAP078*/
             OVRDBF     FILE(DLIDLFEP) TOFILE(DLIDLFEPD) SHARE(*NO)                       /*CAS009*/
             OVRDBF     FILE(FFIMPRIP) TOFILE(FFIMPRIPD) SHARE(*NO)                       /*CAP183*/
             OVRDBF     FILE(SDICUAHP) TOFILE(SDICUAHPD) SHARE(*NO)                      /*CER034A*/
             OVRDBF     FILE(SDIDCMTP) TOFILE(SDIDCMTPD) SHARE(*NO)                       /*CSD093*/
             OVRDBF     FILE(SDIACRVP) TOFILE(SDIACRVPD) SHARE(*NO)                       /*CSD092*/
/**/
             CALL       PGM(AP0005)
             DLTOVR     FILE(*ALL)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/*   Override to correct view of logging file */
/**/
             IF         COND(&TYPE = '1' *OR &TYPE = ' ') THEN(DO)
             OVRDBF     FILE(ZATRNLOG) TOFILE(ZATRNLOGL4) SHARE(*NO)
             ENDDO
             IF         COND(&TYPE = '2') THEN(DO)
             OVRDBF     FILE(ZATRNLOG) TOFILE(ZATRNLOGL5) SHARE(*NO)
             ENDDO
             IF         COND(&TYPE = '3') THEN(DO)
             OVRDBF     FILE(ZATRNLOG) TOFILE(ZATRNLOGL6) SHARE(*NO)
             ENDDO
/*                                                                           /*CAP185*/ /*BUG13549*/
/*           ENDDO                                                           /*CAP185*/ /*BUG13549*/
/**/
/* Call report program     */
/*           IF         COND(&CAP185 *EQ 'Y') THEN(DO)                       /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
/*           CLRPFM     FILE(APTLOGPD)                                       /*CAP185*/ /*BUG13549*/
/*           CALL       PGM(AP0013LE) PARM(&RSEQ &RLEV &RENT &RPARM)         /*CAP185*/ /*BUG13549*/
/*           ENDDO                                                           /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
/*           ELSE       CMD(DO)                                              /*CAP185*/ /*BUG13549*/
             CALL       PGM(AP0003) PARM(&RSEQ &RLEV &RENT &RPARM)
/*           ENDDO                                                           /*CAP185*/ /*BUG13549*/
/*                                                                   */
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
/**/
             ENDDO
/**/
/*   Clear extract file */
/**/
             CLRPFM     FILE(APINVLPD)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination  */
/**/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            APC0003 ended abnormally ') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
/**END:******DLTDTAARA  DTAARA(&TOLIB/APC0003) */                     /*CAP004*/
 END:        DLTDTAARA  DTAARA(&TOLIB/APC0002)                        /*CAP004*/
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
