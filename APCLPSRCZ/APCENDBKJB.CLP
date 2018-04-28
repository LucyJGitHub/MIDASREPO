/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AP End background jobs')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas    - APIs module                                      */
/*                                                                   */
/*       APCENDBKJB  - End background jobs.                          */
/*                                                                   */
/*       Function   - This module ends the various background jobs   */
/*                    required by the APIs.                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CSD092             Date 01May13              */
/*       Prev Amend No. CSD093             Date 01Apr13              */
/*                      MD021155           Date 04Jul13              */
/*                      AR1089839          Date 19Feb13              */
/*                      CCB023             Date 06Aug12              */
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
/*                      CAP078             Date 31Oct02              */
/*                      CAP077             Date 30Aug02              */
/*                      CAP079             Date 19Aug02              */
/*                      CAP075             Date 12Aug02              */
/*                      CAP076             Date 24May02              */
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
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CAP038             Date 21Oct00              */
/*                      CAP057             Date 21Oct00              */
/*                      CAP042             Date 08Jan01              */
/*                      CAP140             Date 17Oct00              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      184380             Date 10Nov00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CAP039             Date 14Jul00              */
/*                      CAP137             Date 07Feb00              */
/*                      CAP136             Date 15Nov99              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CAP034             Date 14Apr99              */
/*                      CAP035             Date 14Apr99              */
/*                      CAP031             Date 14Apr99              */
/*                      CAP032             Date 26Apr99              */
/*                      CAP033             Date 26Apr99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP005             Date 15Oct98              */
/*                      CAP004             Date 01Oct98              */
/*                      CAP003             Date 27Jul98              */
/*                      CAP002  *CREATE    Date 01May98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD092 - Account Review                                     */
/*       CSD093 - Document Management                                */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - Remove call to AOMMODR0                          */
/*       AR1089839 - COBOP and 2.1 source clashes                    */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
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
/*       CAP078 - Lending API enhancements - Fee input               */
/*       CAP077 - Lending API enhancements - Manual repayments       */
/*       CAP079 - Lending API enhancements - Repayments schedule     */
/*       CAP075 - Lending API enhancements - Loan amendments         */
/*       CAP076 - Lending API enhancements - Rollover Instructions   */
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
/*       CAP038 - Midas APIs -Base Rates                             */
/*       CAP057 - Midas APIs -Spot Rates                             */
/*       CAP042 - Conversion of Internal Funding Deal inputs into    */
/*                modular structure to use as APIs.                  */
/*       CAP140 - Conversion of SE Security Diary Event inputs into  */
/*                modular structure to use as APIs.                  */
/*       184380 - Add processing to end PRCS - missed in this program*/
/*       CAP039 - Add SD SECURITIES CUSTOMERS DETAILS                */
/*       CAP137 - Conversion of SE Security inputs into modular      */
/*                structure to use as APIs.                          */
/*       CAP136 - Conversion of FT Incoming Payment inputs into      */
/*                modular structure to use as APIs.                  */
/*       CAP035 - Add GL ACCOUNTS MAINTENANCE                        */
/*       CAP034 - Add SD CUSTOMERS DETAILS                           */
/*       CAP031 - Add FT Outgoing Payments                           */
/*       CAP032 - Conversion of Journal Batch Entry inputs into      */
/*                modular structure to use as APIs.                  */
/*       CAP033 - Conversion of PM inputs into modular structure to  */
/*                use as APIs.                                       */
/*       CAP005 - Conversion of Midas inputs to modular API structure*/
/*                Phase 4 - Add rates imports                        */
/*       CAP004 - Conversion of Midas inputs Phase 3 - AB & FF       */
/*       CAP003 - Conversion of Midas inputs to modular API structure*/
/*                Phase 2                                            */
/*       CAP002 - Conversion of input functions to APIs.             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)             */         /*BUG26776 AR1089839*/
/**********  DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)             */         /*BUG26776 AR1089839*/
/**********  DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)             */         /*BUG26776 AR1089839*/
/**********  DCL        VAR(&SSCSARD) TYPE(*CHAR) LEN(200)         */         /*BUG26776 AR1089839*/
/**********  DCL        VAR(&CAP020) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP021) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP022) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP023) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP024) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP025) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP026) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP027) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP028) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP029) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP030) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP031) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP032) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP033) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP034) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP035) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP036) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP037) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP038) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP039) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP042) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP055) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP057) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP058) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP059) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP060) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP067) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP068) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP069) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP070) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP071) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP072) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP073) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP074) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP075) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP076) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP077) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP078) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP079) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP140) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP182) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAS001) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CSE039) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CSE040) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CGL032) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CAP183) TYPE(*CHAR) LEN(1) VALUE('N' )*/            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CSW207) TYPE(*CHAR) LEN(1) VALUE('N') */            /*BUG26776 CCB023*/
/**********  DCL        VAR(&CER034) TYPE(*CHAR) LEN(1) VALUE('N') */            /*BUG26776 CCB023*/
/**********  DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')            */ /*BUG26776 MD021155*/
/**********  DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')      */ /*BUG26776 MD021155*/
/**********  DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                      */ /*BUG26776 MD021155*/
             DCL        VAR(&CSD093) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD093*/
             DCL        VAR(&CSD092) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD092*/
             DCL        VAR(&SSCSARD) TYPE(*CHAR) LEN(200)                                /*CSD092*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)                                    /*CSD092*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)                                    /*CSD092*/
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                                    /*CSD092*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*******************************************************************/ /*    */ /*BUG26776 MD021155*/
/**********  CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)                */ /*BUG26776 MD021155*/
/*******************************************************************/ /*    */ /*BUG26776 MD021155*/
/***Database*error*handling*****************************************/ /*    */ /*BUG26776 MD021155*/
/*******************************************************************/ /*    */ /*BUG26776 MD021155*/
/**********  IF         COND(&RTCD *NE '       ') THEN(DO)                  */ /*BUG26776 MD021155*/
/**********    SNDPGMMSG  MSG('Error on access to ICD file +                         */ /*MD021155*/
/**********                 AOMMODPD') TOMSGQ(MOPERQ)                       */ /*BUG26776 MD021155*/
/**********    GOTO       CMDLBL(ABNOR)                                     */ /*BUG26776 MD021155*/
/**********  ENDDO                                                          */ /*BUG26776 MD021155*/
 
/***Check*if*the*CAP020*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP020')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP020) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP021*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP021')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP021) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP022*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP022')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP022) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP023*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP023')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP023) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP024*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP024')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP024) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP025*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP025')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP025) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP026*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP026')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP026) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP027*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP027')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP027) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP028*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP028')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP028) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP029*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP029')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP029) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP030*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP030')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP030) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP031*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP031')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP031) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP032*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP032')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP032) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP033*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP033')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP033) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP034*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP034')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP034) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP035*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP035')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP035) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP036*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP036')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP036) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP037*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP037')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP037) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP038*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP038')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP038) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP039*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP039')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP039) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP042*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP042')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP042) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP055*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP055')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP055) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP057*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP057')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP057) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP058*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP058')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP058) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP059*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP059')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP059) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP060*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP060')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP060) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP067*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP067')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP067) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP068*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP068')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP068) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP069*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP069')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP069) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP070*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP070')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP070) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP071*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP071')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP071) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP072*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP072')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP072) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP073*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP073')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP073) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP074*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP074')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP074) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP075*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP075')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP075) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP076*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP076')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP076) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP077*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP077')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP077) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP078*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP078')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP078) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP079*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP079')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP079) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP140*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP140')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP140) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP182*API*Switchable*Feature*is*on****************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP182')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP182) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAS001*Switchable*Feature*is*on********************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAS001')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS001) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CSE039*Switchable*Feature*is*on********************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CSE039')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE039) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CSE040*Switchable*Feature*is*on********************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CSE040')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE040) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAS009*Switchable*Feature*is*on********************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAS009')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS009) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CGL032*Switchable*Feature*is*on********************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CGL032')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL032) VALUE('Y'))                 */            /*BUG26776 CCB023*/
/***Check*if*the*CAP183*Switchable*Feature*is*on********************/            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CAP183')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP183) VALUE('Y'))                 */            /*BUG26776 CCB023*/
                                                                                 /*BUG26776 CCB023*/
/**Check*if*the*CSW207*Switchable*Feature*is*on**/                               /*BUG26776 CCB023*/
                                                                                 /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CSW207')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSW207) VALUE('Y'))                 */            /*BUG26776 CCB023*/
                                                                                 /*BUG26776 CCB023*/
/**Check*if*the*CER034*Switchable*Feature*is*on**/                               /*BUG26776 CCB023*/
                                                                                 /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CER034')                */            /*BUG26776 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */            /*BUG26776 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                          */            /*BUG26776 CCB023*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CER034) VALUE('Y'))                 */            /*BUG26776 CCB023*/
                                                                                 /*BUG26776 CCB023*/
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
/* Determine the system prefix                                      */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)
 
/* +
   Create the API QTEMP objects - only really needed when this   +
    is running as a separate batch job, e.g. in CoB              +
*/
             CALL       PGM(APCCRTQTO) PARM(&RETURNCODE)
             IF         COND(&RETURNCODE *NE ' ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* End the server, called function will check whether it is active  */
             ENDAPISVR  SYSTEM(&SYSTEM)
 
/* End the database updaters, called function will check whether    */
/*  they are active.                                                */
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP003*/
/**********               NASS(Y) FXDL(Y)                          */ /*CAP003*/
                                                                      /*CAP004*/
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP004*/
/***********                   NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) +    */ /*CAP004*/
/***********                   CIRS(Y) DPMV(Y) TRAD(Y)     /*CAP003*/ /*CAP004*/
                                                                      /*CAP004*/
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +     /*CAP005*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +    /*CAP005*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y)  /*CAP004*/ /*CAP005*/
                                                                      /*CAP005*/
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP033*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */ /*CAP033*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/ /*CAP033*/
/***********              INTR(Y)                           */ /*CAP005 CAP033*/
 
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP032*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */ /*CAP032*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/ /*CAP032*/
/***********              INTR(Y) PFDM(Y)                   */ /*CAP033 CAP032*/
                                                                      /*CAP033*/
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP035*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP035*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP035*/
/***********              INTR(Y) PFDM(Y) BITH(Y) BITP(Y)                      /*CAP032*/ /*CAP035*/
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP136*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */ /*CAP136*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/ /*CAP136*/
/***********              INTR(Y) PFDM(Y) BITH(Y) BITP(Y) +        */ /*CAP136*/
/***********              OPAY(Y) CUSD(Y) AMAD(Y)           */ /*CAP035 CAP136*/
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP137*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */ /*CAP137*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/ /*CAP137*/
/***********              INTR(Y) PFDM(Y) BITH(Y) BITP(Y) +        */ /*CAP137*/
/***********              OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y)   */ /*CAP136 CAP137*/
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP039*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */ /*CAP039*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/ /*CAP039*/
/***********              INTR(Y) PFDM(Y) BITH(Y) BITP(Y) +        */ /*CAP039*/
/***********              OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) +        */ /*CAP039*/
/***********              SECS(Y)                                  */ /*CAP137*/ /*CAP039*/
/*********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*184380*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */ /*184380*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/ /*184380*/
/***********              INTR(Y) PFDM(Y) BITH(Y) BITP(Y) +        */ /*184380*/
/***********              OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) +        */ /*184380*/
/***********              SECS(Y) SECD(Y)                             /*CAP039*/ /*184380*/
/*/COPY WNCPYSRC,APCENDBK01                                          */
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +  */                     /*CAP140*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */                     /*CAP140*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/                     /*CAP140*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +*/                     /*CAP140*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) +        */                     /*CAP140*/
/**********               SECS(Y) SECD(Y)                          */              /*184380 CAP140*/
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +   */                    /*CAP057*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +  */                    /*CAP057*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) + */                    /*CAP057*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) + */                    /*CAP057*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) +         */                    /*CAP057*/
/**********               SECS(Y) SECD(Y) SEDE(Y)                   */         /*CAP140*/ /*CAP057*/
                                                                                          /*CAP057*/
/**********                                                         */                    /*CAP038*/
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +   */                    /*CAP038*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +  */                    /*CAP038*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) + */                    /*CAP038*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) + */                    /*CAP038*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) + */                    /*CAP038*/
/**********               SECD(Y) SEDE(Y) SPTR(Y)                   */         /*CAP057*/ /*CAP038*/
                                                                                          /*CAP038*/
/**********                                                         */                    /*CAP042*/
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +   */                    /*CAP042*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +  */                    /*CAP042*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) + */                    /*CAP042*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) + */                    /*CAP042*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) + */                    /*CAP042*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y)           */         /*CAP038*/ /*CAP042*/
/**********                                                         */                    /*CAP070*/
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +   */                    /*CAP070*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +  */                    /*CAP070*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) + */                    /*CAP070*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) + */                    /*CAP070*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) + */                    /*CAP070*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y)   */         /*CAP042*/ /*CAP070*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAS001*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAS001*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAS001*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAS001*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAS001*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAS001*/
/**********               REPO(Y) BYSL(Y)                                      /*CAP070*/ /*CAS001*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP070*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP070*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP070*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP070*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP070*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP070*/
/**********               REPO(Y) BYSL(Y) YRAT(Y)                              /*CAS001*/ /*CAP070*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP069*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP069*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP069*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP069*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP069*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP069*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) +                                       /*CAP069*/
/**********               ASGN(Y)                                              /*CAP070*/ /*CAP069*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP068*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP068*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP068*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP068*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP068*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP068*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) +                                       /*CAP068*/
/**********               ASGN(Y) RPRT(Y)                                      /*CAP069*/ /*CAP068*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP071*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP071*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP071*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP071*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP071*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP071*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) +                                       /*CAP071*/
/**********               ASGN(Y) RPRT(Y) FPRT(Y)                              /*CAP068*/ /*CAP071*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP072*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP072*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP072*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP072*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP072*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP072*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) +                                       /*CAP072*/
/**********               ASGN(Y) RPRT(Y) FPRT(Y) FAMD(Y)                      /*CAP071*/ /*CAP072*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +   */         /*CAP072*/ /*CAP055*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +  */         /*CAP072*/ /*CAP055*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) + */         /*CAP072*/ /*CAP055*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) + */         /*CAP072*/ /*CAP055*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) + */         /*CAP072*/ /*CAP055*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) + */         /*CAP072*/ /*CAP055*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) +                 */         /*CAP072*/ /*CAP055*/
/**********               ASGN(Y) RPRT(Y) FPRT(Y) FAMD(Y) FEAD(Y) + */         /*CAP072*/ /*CAP055*/
/**********               FEST(Y)                                   */         /*CAP072*/ /*CAP055*/
 
 /********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +              /*CAP055*/ /*CSE039*/
 /**********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +             /*CAP055*/ /*CSE039*/
 /**********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +            /*CAP055*/ /*CSE039*/
 /**********              INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +            /*CAP055*/ /*CSE039*/
 /**********              OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +            /*CAP055*/ /*CSE039*/
 /**********              SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +            /*CAP055*/ /*CSE039*/
 /**********              REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +            /*CAP055*/ /*CSE039*/
 /**********              FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y)              /*CAP055*/ /*CSE039*/
 
 /********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +              /*CSE039*/ /*CAP182*/
 /**********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +             /*CSE039*/ /*CAP182*/
 /**********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +            /*CSE039*/ /*CAP182*/
 /**********              INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +            /*CSE039*/ /*CAP182*/
 /**********              OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +            /*CSE039*/ /*CAP182*/
 /**********              SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +            /*CSE039*/ /*CAP182*/
 /**********              REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +            /*CSE039*/ /*CAP182*/
 /**********              FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y)              /*CSE039*/ /*CAP182*/
 /**********              MVTS(Y)                                              /*CSE039*/ /*CAP182*/
 
 /********** ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +              /*CAP182*/ /*CSE040*/
 /**********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +             /*CAP182*/ /*CSE040*/
 /**********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +            /*CAP182*/ /*CSE040*/
 /**********              INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +            /*CAP182*/ /*CSE040*/
 /**********              OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +            /*CAP182*/ /*CSE040*/
 /**********              SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +            /*CAP182*/ /*CSE040*/
 /**********              REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +            /*CAP182*/ /*CSE040*/
 /**********              FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +            /*CAP182*/ /*CSE040*/
 /**********              MVTS(Y) TRSM(Y)                                      /*CAP182*/ /*CSE040*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP073*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP073*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP073*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP073*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP073*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP073*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CAP073*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CAP073*/
/**********               MVTS(Y) TRSM(Y) STPR(Y)                              /*CSE040*/ /*CAP073*/
                                                                                          /*CAP055*/
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP074*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP074*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP074*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP074*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP074*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP074*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CAP074*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CAP074*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y)                      /*CAP073*/ /*CAP074*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP076*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP076*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP076*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP076*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP076*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP076*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CAP076*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CAP076*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y)              /*CAP074*/ /*CAP076*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP075*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP075*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP075*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP075*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP075*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP075*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CAP075*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CAP075*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                       /*CAP075*/
/**********               LERI(Y)                                              /*CAP076*/ /*CAP075*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP079*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP079*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP079*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP079*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP079*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP079*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CAP079*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CAP079*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                       /*CAP079*/
/**********               LERI(Y) LOAM(Y)                                      /*CAP075*/ /*CAP079*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP077*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP077*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP077*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP077*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP077*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP077*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CAP077*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CAP077*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                       /*CAP077*/
/**********               LERI(Y) LOAM(Y) RPSC(Y)                              /*CAP079*/ /*CAP077*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                      */ /*CAP078*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                     */ /*CAP078*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                    */ /*CAP078*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                    */ /*CAP078*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                    */ /*CAP078*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                    */ /*CAP078*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                    */ /*CAP078*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                    */ /*CAP078*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                    */ /*CAP078*/
/**********               LERI(Y) LOAM(Y) RPSC(Y) MAPY(Y)                   */ /*CAP077*/ /*CAP078*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAS009*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAS009*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAS009*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAS009*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAS009*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAS009*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CAS009*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CAS009*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                       /*CAS009*/
/**********               LERI(Y) LOAM(Y) RPSC(Y) MAPY(Y) FEEM(Y)              /*CAP078*/ /*CAS009*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CGL032*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CGL032*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CGL032*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CGL032*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CGL032*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CGL032*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CGL032*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CGL032*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                       /*CGL032*/
/**********               LERI(Y) LOAM(Y) RPSC(Y) MAPY(Y) FEEM(Y) +                       /*CGL032*/
/**********               DLFE(Y)                                              /*CAS009*/ /*CGL032*/
 
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP183*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP183*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP183*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP183*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP183*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                       /*CAP183*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                       /*CAP183*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                       /*CAP183*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                       /*CAP183*/
/**********               LERI(Y) LOAM(Y) RPSC(Y) MAPY(Y) FEEM(Y) +                       /*CAP183*/
/**********               DLFE(Y) ACUD(Y) CCTX(Y) JACM(Y) NAHL(Y) +                       /*CAP183*/
/**********               NATX(Y)                                              /*CGL032*/ /*CAP183*/
                                                                                          /*CGL032*/
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                        /*CER034A*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                       /*CER034A*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                      /*CER034A*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                      /*CER034A*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                      /*CER034A*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                      /*CER034A*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                      /*CER034A*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                      /*CER034A*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                      /*CER034A*/
/**********               LERI(Y) LOAM(Y) RPSC(Y) MAPY(Y) FEEM(Y) +                      /*CER034A*/
/**********               DLFE(Y) ACUD(Y) CCTX(Y) JACM(Y) NAHL(Y) +                      /*CER034A*/
/**********               NATX(Y) MPRI(Y)                                     /*CAP183*/ /*CER034A*/
/**********  ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +                       /*BUG26776*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                      /*BUG26776*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                     /*BUG26776*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                     /*BUG26776*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                     /*BUG26776*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +                     /*BUG26776*/
/**********               REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +                     /*BUG26776*/
/**********               FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +                     /*BUG26776*/
/**********               MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +                     /*BUG26776*/
/**********               LERI(Y) LOAM(Y) RPSC(Y) MAPY(Y) FEEM(Y) +                     /*BUG26776*/
/**********               DLFE(Y) ACUD(Y) CCTX(Y) JACM(Y) NAHL(Y) +                     /*BUG26776*/
/**********               NATX(Y) MPRI(Y) CUAH(Y)                           /*CER034A*/ /*BUG26776*/
                                                                                          /*CAP183*/
/**********  IF         COND(&CAP020 *EQ 'Y' *AND %SST(&FMT 48 1) +
                          *EQ 'Y') THEN(ENDAPIDBU SYSTEM(&SYSTEM) +
                          LDNI(Y) DEAM(Y))                         */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP021 *EQ 'Y' *AND %SST(&FMT 48 1) +
                          *EQ 'Y') THEN(ENDAPIDBU SYSTEM(&SYSTEM) +
                          NASP(Y) NASS(Y))                         */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP022 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) FXDL(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP023 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM)  FRA(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP024 *EQ 'Y' *AND %SST(&FMT 47 1) +
                          *EQ 'Y') THEN(ENDAPIDBU SYSTEM(&SYSTEM) +
                          SIRS(Y) CIRS(Y))                         */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP025 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) TRAD(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP026 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) DPMV(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP027 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) INTC(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP028 *EQ 'Y' *AND %SST(&FMT 41 1) +
                          *EQ 'Y') THEN(ENDAPIDBU SYSTEM(&SYSTEM) +
                          TRAN(Y))                                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP029 *EQ 'Y' *OR  &CAP058 *EQ 'Y') +
                          THEN(ENDAPIDBU SYSTEM(&SYSTEM) INTR(Y))  */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP029 *EQ 'Y' *OR  &CAP059 *EQ 'Y') +
                          THEN(ENDAPIDBU SYSTEM(&SYSTEM) FWRT(Y))  */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP030 *EQ 'Y' *OR  &CAP060 *EQ 'Y') +
                          THEN(ENDAPIDBU SYSTEM(&SYSTEM) PRCS(Y))  */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP031 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) OPAY(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP032 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) BITH(Y) BITP(Y))         */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP033 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) PFDM(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP034 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) CUSD(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP035 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) AMAD(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP036 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) IPAY(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP037 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) SECS(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP038 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) BSRT(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP039 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) SECD(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP042 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) FUND(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP055 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) CACF(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP057 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) SPTR(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP067 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) BYSL(Y) REPO(Y))         */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP068 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) FPRT(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP069 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) RPRT(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP070 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) ASGN(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP071 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) FAMD(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP072 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) FEAD(Y) FEST(Y))         */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP073 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) FCIP(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP074 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) CLIP(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP075 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) LOAM(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP076 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) LERI(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP077 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) MAPY(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP078 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) FEEM(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP079 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) RPSC(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP140 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) SEDE(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP182 *EQ 'Y' *AND %SST(&FMT 31 1) +
                          *EQ 'Y') THEN(ENDAPIDBU SYSTEM(&SYSTEM) +
                          TRSM(Y))                                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAS001 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) YRAT(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CSE039 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) MVTS(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CSE040 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) STPR(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAS009 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) DLFE(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CGL032 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) ACUD(Y) CCTX(Y) JACM(Y) +
                          NAHL(Y) NATX(Y))                         */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CAP183 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) MPRI(Y))                 */            /*BUG26776 CCB023*/
 
/**********  IF         COND(&CSW207 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) ACUD(Y))                 */     /*BUG26776*/ /*AR1026621*/
/**********  IF         COND(&CSW207 *EQ 'Y') THEN(ENDAPIDBU +     */                  /*AR1089839*/
/**********               SYSTEM(&SYSTEM) ACUD(Y) JACM(Y) NAHL(Y)) */        /*AR1026621 AR1089839*/
                                                                                        /*BUG26776*/
/**********  IF         COND(&CER034 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) CUAH(Y))                 */            /*BUG26776 CCB023*/
                                                                                        /*BUG26776*/
             IF         COND(&CSD093 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) DCMT(Y))                                        /*CSD093*/
                                                                                          /*CSD093*/
             IF         COND(&CSD092 *EQ 'Y') THEN(ENDAPIDBU +
                          SYSTEM(&SYSTEM) ACRV(Y))                                        /*CSD092*/
                                                                                          /*CSD092*/
             ENDAPIDBU  SYSTEM(&SYSTEM) LDNI(Y) DEAM(Y) NASP(Y) +
                          NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +
                          DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +
                          INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +
                          OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +
                          SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y) +
                          REPO(Y) BYSL(Y) YRAT(Y) ASGN(Y) RPRT(Y) +
                          FPRT(Y) FAMD(Y) FEAD(Y) FEST(Y) CACF(Y) +
                          MVTS(Y) TRSM(Y) STPR(Y) FCIP(Y) CLIP(Y) +
                          LOAM(Y) LERI(Y) MAPY(Y) FEEM(Y) RPSC(Y) +
                          DLFE(Y) ACUD(Y) CCTX(Y) JACM(Y) NAHL(Y) +
                          NATX(Y) MPRI(Y) CUAH(Y)                                         /*CCB023*/
                                                                                          /*CCB023*/
/*/COPY WNCPYSRC,APCENDBK02                                          */
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          APCENDBKJB ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
