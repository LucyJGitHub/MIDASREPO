/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AP Start API background jobs')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas    - APIs module                                      */
/*                                                                   */
/*       APCSTRBKJB - Start background jobs.                         */
/*                                                                   */
/*       Function   - This module starts the various background jobs */
/*                    required by the APIs.                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CSD092             Date 01May13              */
/*       Prev Amend No. CSD093             Date 01Apr13              */
/*                      AR1026621          Date 15Oct12              */
/*                      CER059             Date 19Jul10              */
/*                      BUG26776           Date 19Nov09              */
/*                      CER034A            Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CAP183             Date 05Jan06              */
/*                      CGL032             Date 05Jul04              */
/*                      CAS009             Date 04May04              */
/*                      CAP079             Date 19Aug02              */
/*                      CAP078             Date 31Oct02              */
/*                      CAP077             Date 30Aug02              */
/*                      CAP076             Date 24May02              */
/*                      CAP075             Date 12Aug02              */
/*                      CAP074             Date 26Mar02              */
/*                      CAP073             Date 18May02              */
/*                      CSE040             Date 28Mar03              */
/*                      CAP182             Date 14Mar03              */
/*                      CSE039             Date 07Mar03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAP055             Date 13Mar02              */
/*                      CAP072             Date 27Mar02              */
/*                      CAP071             Date 22Mar02              */
/*                      CAP068             Date 22Mar02              */
/*                      CAP069             Date 11Mar02              */
/*                      CAP070             Date 11Mar02              */
/*                      CAS001             Date 23Nov01              */
/*                      CAP067             Date 24Sep01              */
/*                      CPK015             Date 02Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CAP042             Date 08Jan01              */
/*                      CAP038             Date 21Oct00              */
/*                      CAP057             Date 21Oct00              */
/*                      CAP140             Date 17Oct00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CAP039             Date 14Jul00              */
/*                      CAP137             Date 07Feb00              */
/*                      CAP136             Date 15Nov99              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CAP035             Date 14Apr99              */
/*                      CAP034             Date 14Apr99              */
/*                      CAP031             Date 14Apr99              */
/*                      CAP032             Date 26Apr99              */
/*                      CAP033             Date 26Apr99              */
/*                      173227             Date 05Jan00              */
/*                      169282             Date 15Oct99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CAP030             Date 15Mar99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP005             Date 15Oct98              */
/*                      CAP004             Date 01Oct98              */
/*                      CAP003             Date 27Jul98              */
/*                      CAP002  *CREATE    Date 01May98              */
/*                                         Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD092 - Account Review                                     */
/*       CSD093 - Document Management                                */
/*       AR1026621 - DBU JACM and NAHL did not restart automatically */
/*                   after COB (Child:AR1026623)                     */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG26776 - Run only API jobs based on system settings in    */
/*                  SCSARDPD and SDMMODPD.                           */
/*       CER034A - German Features - New Fields and Enquiries        */
/*       CAP183 - Conversion of Market Prices Input into modular     */
/*                structure to use APIs                              */
/*       CGL032 - Automatic Exchange of Information                  */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CAP079 - Lending API enhancements - Repayments schedule     */
/*       CAP078 - Lending API enhancements - Fee input               */
/*       CAP077 - Lending API enhancements - Manual repayments       */
/*       CAP076 - Lending API enhancements - Rollover Instructions   */
/*       CAP075 - Lending API enhancements - Loan amendments         */
/*       CAP074 - Lending API enhancements - Loans input.            */
/*       CAP073 - Conversion of MN inputs into modular structure to  */
/*           use as APIs. Facility input Transaction Details         */
/*       CSE040 - Securities Statement Processing                    */
/*       CAP182 - Automatic Settlement of Trades                     */
/*              - Conversion of SE Trade Settlement Input maintence  */
/*                function to modular structure to use as APIs.      */
/*       CSE039 - Automatic Settlement of Trades                     */
/*       CAP055 - APIs for FRA/IRS Caps/Collars/Floors               */
/*       CAP072 - Conversion of LE inputs into modular structure to  */
/*                use as APIs. Fee Settlement and Adjustment input   */
/*       CAP071 - Conversion of LE inputs into modular structure to  */
/*                use as APIs. Facility Amendment.                   */
/*       CAP068 - Conversion of LE inputs into modular structure to  */
/*                use as APIs. Funding Participants.                 */
/*       CAP069 - Conversion of LE inputs into modular structure to  */
/*                use as APIs. Risk Participants.                    */
/*       CAP070 - Conversion of LE inputs into modular structure to  */
/*                use as APIs.                                       */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*       CAP067 - Repurchase Agreements API.                         */
/*       CPK015 - Program code stripped and rewritten to ease maint. */
/*       CAP042 - Conversion of Internal Funding Deal inputs into    */
/*                modular structure to use as APIs.                  */
/*       CAP038 - Midas APIs -Base Rates                             */
/*       CAP057 - Midas APIs -Spot Rates                             */
/*       CAP140 - Conversion of SE Security Diary Event inputs into  */
/*                                                                   */
/*       CAP039 - Add processing for SD SECURITY CUSTOMER DETAILS    */
/*       CAP137 - Conversion of SE Security inputs into modular      */
/*                structure to use as APIs.                          */
/*       CAP136 - Conversion of FT Incoming Payment inputs into      */
/*                modular structure to use as APIs.                  */
/*       CAP035 - Add processing for G/L ACCOUNTS MAINTENANCE        */
/*       CAP034 - Add processing for SD CUSTOMERS DETAILS            */
/*       CAP031 - Add processing for FT Outgoing Payments            */
/*       CAP032 - Conversion of Journal Batch Entry inputs into      */
/*                modular structure to use as APIs.                  */
/*       CAP033 - Conversion of PM inputs into modular structure to  */
/*                use as APIs.                                       */
/*       173227 - Reinstate CAP005                                   */
/*       169282 - Remove set up of LCD packed data                   */
/*                Recompile over changed /COPY APCICDACC             */
/*       CAP030 - APIs for SE Price Input                            */
/*       CAP005 - Conversion of Midas inputs to modular API structure*/
/*                Phase 4 - Add rates imports                        */
/*       CAP004 - Conversion of Midas inputs Phase 3 - AB & FF       */
/*       CAP003 - Conversion of Midas inputs to modular API structure*/
/*                Phase 2                                            */
/*       CAP002 - Conversion of input functionss to APIs.            */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                                  /*BUG26776*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)                                  /*BUG26776*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)                                  /*BUG26776*/
             DCL        VAR(&SSCSARD) TYPE(*CHAR) LEN(200)                              /*BUG26776*/
             DCL        VAR(&CAP020) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP021) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP022) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP023) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP024) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP025) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP026) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP027) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP028) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP029) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP030) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP031) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP032) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP033) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP034) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP035) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP036) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP037) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP038) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP039) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP042) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP055) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP057) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP058) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP059) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP060) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP067) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP068) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP069) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP070) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP071) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP072) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP073) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP074) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP075) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP076) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP077) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP078) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP079) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP140) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP182) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAS001) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CSE039) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CSE040) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CGL032) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CAP183) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*BUG26776*/
             DCL        VAR(&CSW207) TYPE(*CHAR) LEN(1) VALUE('N')                      /*BUG26776*/
             DCL        VAR(&CER034) TYPE(*CHAR) LEN(1) VALUE('N')                      /*BUG26776*/
             DCL        VAR(&CSD093) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD093*/
             DCL        VAR(&CSD092) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD092*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                        /*BUG26776*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')                  /*BUG26776*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                  /*BUG26776*/
 
/* Declares for accessing the API ICD file                          */
/*/COPY APCPYSRC,APCICDDCL                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/                                                                                    /*BUG26776*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)                            /*BUG26776*/
/**/                                                                                    /*BUG26776*/
/** Database error handling                                        */                   /*BUG26776*/
/**/                                                                                    /*BUG26776*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                              /*BUG26776*/
               SNDPGMMSG  MSG('Error on access to ICD file +
                            AOMMODPD') TOMSGQ(MOPERQ)                                   /*BUG26776*/
               GOTO       CMDLBL(ABNOR)                                                 /*BUG26776*/
             ENDDO                                                                      /*BUG26776*/
 
/*  Check if the CAP020 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP020')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP020) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP021 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP021')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP021) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP022 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP022')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP022) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP023 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP023')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP023) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP024 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP024')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP024) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP025 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP025')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP025) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP026 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP026')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP026) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP027 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP027')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP027) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP028 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP028')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP028) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP029 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP029')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP029) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP030 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP030')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP030) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP031 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP031')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP031) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP032 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP032')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP032) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP033 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP033')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP033) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP034 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP034')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP034) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP035 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP035')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP035) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP036 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP036')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP036) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP037 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP037')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP037) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP038 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP038')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP038) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP039 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP039')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP039) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP042 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP042')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP042) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP055 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP055')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP055) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP057 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP057')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP057) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP058 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP058')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP058) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP059 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP059')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP059) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP060 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP060')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP060) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP067 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP067')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP067) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP068 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP068')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP068) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP069 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP069')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP069) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP070 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP070')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP070) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP071 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP071')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP071) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP072 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP072')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP072) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP073 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP073')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP073) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP074 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP074')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP074) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP075 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP075')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP075) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP076 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP076')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP076) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP077 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP077')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP077) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP078 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP078')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP078) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP079 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP079')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP079) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP140 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP140')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP140) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP182 API Switchable Feature is on                                    /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP182')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP182) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAS001 Switchable Feature is on                                        /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAS001')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS001) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CSE039 Switchable Feature is on                                        /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CSE039')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE039) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CSE040 Switchable Feature is on                                        /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CSE040')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE040) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAS009 Switchable Feature is on                                        /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAS009')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS009) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CGL032 Switchable Feature is on                                        /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CGL032')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL032) VALUE('Y'))                                      /*BUG26776*/
/*  Check if the CAP183 Switchable Feature is on                                        /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CAP183')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP183) VALUE('Y'))                                      /*BUG26776*/
                                                                                        /*BUG26776*/
/* Check if the CSW207 Switchable Feature is on */                                      /*BUG26776*/
                                                                                        /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CSW207')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSW207) VALUE('Y'))                                      /*BUG26776*/
                                                                                        /*BUG26776*/
/* Check if the CER034 Switchable Feature is on */                                      /*BUG26776*/
                                                                                        /*BUG26776*/
             CHGVAR     VAR(&SSARD) VALUE('CER034')                                     /*BUG26776*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                    /*BUG26776*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                               /*BUG26776*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CER034) VALUE('Y'))                                      /*BUG26776*/
                                                                                        /*BUG26776*/
/* Check if the CSD093 Switchable Feature is on */                                        /*CSD093*/
                                                                                          /*CSD093*/
             CHGVAR     VAR(&SSARD) VALUE('CSD093')                                       /*CSD093*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                      /*CSD093*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                                 /*CSD093*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSD093) VALUE('Y'))                                        /*CSD093*/
                                                                                          /*CSD093*/
/* Check if the CSD092 Switchable Feature is on */                                        /*CSD092*/
                                                                                          /*CSD092*/
             CHGVAR     VAR(&SSARD) VALUE('CSD092')                                       /*CSD092*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                      /*CSD092*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                                 /*CSD092*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSD092) VALUE('Y'))                                        /*CSD092*/
                                                                                          /*CSD092*/
/* Access the API ICD file and set up the fields                    */
/*/COPY APCPYSRC,APCICDACC                                          */
 
/* Determine the system prefix                                      */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)
 
/* +
   Create the API QTEMP objects - only really needed when this   +
    is running as a separate batch job, e.g. in CoB              +
*/
             CALL       PGM(APCCRTQTO) PARM(&RETURNCODE)
             IF         COND(&RETURNCODE *NE ' ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* If required, start the server                                    */
             IF         COND(&GHSTSV *EQ 'Y') THEN(DO)
                STRAPISVR  SYSTEM(&SYSTEM)
             ENDDO
 
/* If required, start the database updaters                         */
             IF         COND(&GHSTDU *EQ 'Y') THEN(DO)
 
/*/COPY WNCPYSRC,APCSBKJB01                                         */
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) LDNI(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) DEAM(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) NASP(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) NASS(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FXDL(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FRA(Y)                      */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) SIRS(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) CIRS(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) DPMV(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) TRAD(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) TRAN(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) INTC(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FWRT(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) INTR(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) PRCS(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) PFDM(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) BITH(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) BITP(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) OPAY(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) CUSD(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) AMAD(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) IPAY(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) SECS(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) SECD(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) SEDE(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) SPTR(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) BSRT(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FUND(Y)                     */                  /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) REPO(Y)                     */       /*CAP067*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) BYSL(Y)                     */       /*CAP067*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) YRAT(Y)                     */       /*CAS001*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) ASGN(Y)                     */       /*CAP070*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) RPRT(Y)                     */       /*CAP069*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FPRT(Y)                     */       /*CAP068*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FAMD(Y)                     */       /*CAP071*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FEAD(Y)                     */       /*CAP072*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FEST(Y)                     */       /*CAP072*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) CACF(Y)                     */       /*CAP055*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) MVTS(Y)                     */       /*CAP182*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) TRSM(Y)                     */       /*CSE039*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) STPR(Y)                     */       /*CSE040*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FCIP(Y)                     */       /*CAP073*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) CLIP(Y)                     */       /*CAP074*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) LOAM(Y)                     */       /*CAP075*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) LERI(Y)                     */       /*CAP076*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) MAPY(Y)                     */       /*CAP077*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) FEEM(Y)                     */       /*CAP078*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) RPSC(Y)                     */       /*CAP079*/ /*BUG26776*/
 
/*********   STRAPIDBU  SYSTEM(&SYSTEM) DLFE(Y)                     */       /*CAS009*/ /*BUG26776*/
/*********                                                          */       /*CAS009*/ /*BUG26776*/
/*********   STRAPIDBU  SYSTEM(&SYSTEM) ACUD(Y)                     */       /*CGL032*/ /*BUG26776*/
/*********                                                          */       /*CGL032*/ /*BUG26776*/
/*********   STRAPIDBU  SYSTEM(&SYSTEM) CCTX(Y)                     */       /*CGL032*/ /*BUG26776*/
/*********                                                          */       /*CGL032*/ /*BUG26776*/
/*********   STRAPIDBU  SYSTEM(&SYSTEM) JACM(Y)                     */       /*CGL032*/ /*BUG26776*/
/*********                                                          */       /*CGL032*/ /*BUG26776*/
/*********   STRAPIDBU  SYSTEM(&SYSTEM) NAHL(Y)                     */       /*CGL032*/ /*BUG26776*/
/*********                                                          */       /*CGL032*/ /*BUG26776*/
/*********   STRAPIDBU  SYSTEM(&SYSTEM) NATX(Y)                     */       /*CGL032*/ /*BUG26776*/
/*********                                                          */       /*CGL032*/ /*BUG26776*/
/*********   STRAPIDBU  SYSTEM(&SYSTEM) MPRI(Y)                     */       /*CAP183*/ /*BUG26776*/
                                                                                         /*CER034A*/
/*********   STRAPIDBU  SYSTEM(&SYSTEM) CUAH(Y)                             /*CER034A*/ /*BUG26776*/
                                                                                        /*BUG26776*/
             IF         COND(&CAP020 *EQ 'Y' *AND %SST(&FMT 48 1) +
                          *EQ 'Y') THEN(STRAPIDBU SYSTEM(&SYSTEM) +
                          LDNI(Y) DEAM(Y))                                              /*BUG26776*/
 
             IF         COND(&CAP021 *EQ 'Y' *AND %SST(&FMT 48 1) +
                          *EQ 'Y') THEN(STRAPIDBU SYSTEM(&SYSTEM) +
                          NASP(Y) NASS(Y))                                              /*BUG26776*/
 
             IF         COND(&CAP022 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) FXDL(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP023 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM)  FRA(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP024 *EQ 'Y' *AND %SST(&FMT 47 1) +
                          *EQ 'Y') THEN(STRAPIDBU SYSTEM(&SYSTEM) +
                          SIRS(Y) CIRS(Y))                                              /*BUG26776*/
 
             IF         COND(&CAP025 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) TRAD(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP026 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) DPMV(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP027 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) INTC(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP028 *EQ 'Y' *AND %SST(&FMT 41 1) +
                          *EQ 'Y') THEN(STRAPIDBU SYSTEM(&SYSTEM) +
                           TRAN(Y))                                                     /*BUG26776*/
 
             IF         COND(&CAP029 *EQ 'Y' *OR  &CAP058 *EQ 'Y') +
                          THEN(STRAPIDBU SYSTEM(&SYSTEM) INTR(Y))                       /*BUG26776*/
 
             IF         COND(&CAP029 *EQ 'Y' *OR  &CAP059 *EQ 'Y') +
                          THEN(STRAPIDBU SYSTEM(&SYSTEM) FWRT(Y))                       /*BUG26776*/
 
             IF         COND(&CAP030 *EQ 'Y' *OR  &CAP060 *EQ 'Y') +
                          THEN(STRAPIDBU SYSTEM(&SYSTEM) PRCS(Y))                       /*BUG26776*/
 
             IF         COND(&CAP031 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) OPAY(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP032 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) BITH(Y) BITP(Y))                              /*BUG26776*/
 
             IF         COND(&CAP033 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) PFDM(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP034 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) CUSD(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP035 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) AMAD(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP036 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) IPAY(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP037 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) SECS(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP038 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) BSRT(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP039 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) SECD(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP042 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) FUND(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP055 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) CACF(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP057 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) SPTR(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP067 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) BYSL(Y) REPO(Y))                              /*BUG26776*/
 
             IF         COND(&CAP068 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) FPRT(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP069 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) RPRT(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP070 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) ASGN(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP071 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) FAMD(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP072 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) FEAD(Y) FEST(Y))                              /*BUG26776*/
 
             IF         COND(&CAP073 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) FCIP(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP074 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) CLIP(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP075 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) LOAM(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP076 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) LERI(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP077 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) MAPY(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP078 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) FEEM(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP079 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) RPSC(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP140 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) SEDE(Y))                                      /*BUG26776*/
 
             IF         COND(&CAP182 *EQ 'Y' *AND %SST(&FMT 31 1) +
                          *EQ 'Y') THEN(STRAPIDBU SYSTEM(&SYSTEM) +
                          TRSM(Y))                                                      /*BUG26776*/
 
             IF         COND(&CAS001 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) YRAT(Y))                                      /*BUG26776*/
 
             IF         COND(&CSE039 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) MVTS(Y))                                      /*BUG26776*/
 
             IF         COND(&CSE040 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) STPR(Y))                                      /*BUG26776*/
 
             IF         COND(&CAS009 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) DLFE(Y))                                      /*BUG26776*/
 
             IF         COND(&CGL032 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) ACUD(Y) CCTX(Y) JACM(Y) +
                          NAHL(Y) NATX(Y))                                              /*BUG26776*/
 
             IF         COND(&CAP183 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) MPRI(Y))                                      /*BUG26776*/
                                                                                        /*BUG26776*/
/**********  IF         COND(&CSW207 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) ACUD(Y))                   */   /*BUG26776*/ /*AR1026621*/
             IF         COND(&CSW207 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) ACUD(Y) JACM(Y) NAHL(Y))                     /*AR1026621*/
                                                                                        /*BUG26776*/
             IF         COND(&CER034 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) CUAH(Y))                                      /*BUG26776*/
 
             IF         COND(&CSD093 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) DCMT(Y))                                        /*CSD093*/
 
             IF         COND(&CSD092 *EQ 'Y') THEN(STRAPIDBU +
                          SYSTEM(&SYSTEM) ACRV(Y))                                        /*CSD092*/
 
/*/COPY WNCPYSRC,APCSBKJB02                                         */
 
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          APCSTRBKJB ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
