/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD COB customer deletion control')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0013 - COB Customer Deletion Control.                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSD028             Date 22Aug05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/*                      146350             DATE 15Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      S01408             DATE 10MAY95              */
/*                      077335             DATE 09NOV94              */
/*                      S01486             DATE 18JUL94              */
/*                      069253             DATE 13APR94              */
/*                      S01421             DATE 20JUL93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CSD028 - KYC (Standing Data Authorisations)                 */
/*       CCB009 - Journal files throughout close of business         */
/*       146350 - CoB fails  with SDCCRDPD not journaled as files    */
/*                SDPATTPD, SDJUSRPD, SDRELCPD & SDCCRDPD added by   */
/*                CPM005 were overlooked.                            */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01408 - Addition of core hook SDC0013MPS                   */
/*       077335 - The journal and journal reciever should be         */
/*                created in the JLIB rather than in the XLIB.       */
/*                Call SD0011X with parameter QUIT = 'Y' to close    */
/*                down SD0011X, SD0010U and SD0340U.                 */
/*       S01486 - Private Banking Development:                       */
/*                - Add processing for Portfolio Lending module      */
/*                - Add processing for Portfolio Management module   */
/*       069253 - Include BRT details in deletion                    */
/*       S01421 - New program created as part of the BLI phase one   */
/*                development.                                       */
/*                - Includes changes for:                            */
/*                  S01424 - Automatic customer deletion during      */
/*                           close of business.                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
/*****       DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)          */    /*077335*/
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)                /*077335*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*077335*/
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(6)                 /*077335*/
             DCL        VAR(&RTNCDE2) TYPE(*CHAR) LEN(7)              /*077335*/
             DCL        VAR(&STRING1) TYPE(*CHAR) LEN(200)            /*077335*/
             DCL        VAR(&STRING2) TYPE(*CHAR) LEN(200)            /*077335*/
             DCL        VAR(&STRING3) TYPE(*CHAR) LEN(200)            /*077335*/
             DCL        VAR(&STRING4) TYPE(*CHAR) LEN(200)            /*077335*/
             DCL        VAR(&STRING5) TYPE(*CHAR) LEN(200)            /*077335*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,SDC0013004                                          */
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
/* Retrieve the system prefix */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/*/COPY WNCPYSRC,SDC0013005                                          */
 
/* Start commitment control */
 
/************STRCMTCTL  LCKLVL(*CHG)                                      /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
                                                                          /*CPK009*/
/*************Build the name of the target XLIB****** */              /*077335*/
/************CHGVAR     VAR(&XLIB) VALUE(&PREFIX *CAT 'XLIB')   */    /*077335*/
/* Build the name of the target JLIB */                               /*077335*/
                                                                      /*077335*/
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')         /*077335*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC0013MPS                                          */
                                                                      /*S01408*/
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* Delete any existing journal/journal receiver */
 
             ENDJRNPF   FILE(CLINTCA)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(CLINTCB)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(CLINTCC)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(CLINTC1)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(CLINTSE)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(FOCLTA)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(FOCLTD)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(SDCUSTPD)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(SDALTNPD)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(SDACUSPD)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(SDCFCDPD)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(SDCMRKPD)
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,SDC0013001                                          */
 
             ENDJRNPF   FILE(SDFOCSPD)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(SDSECSPD)
             MONMSG     MSGID(CPF0000)
 
             ENDJRNPF   FILE(SDFCTLPA)
             MONMSG     MSGID(CPF0000)
                                                                      /*069253*/
             ENDJRNPF   FILE(SDCBRTPD)                                /*069253*/
             MONMSG     MSGID(CPF0000)                                /*069253*/
                                                                      /*069253*/
             ENDJRNPF   FILE(PTYHSTPD)                                /*069253*/
             MONMSG     MSGID(CPF0000)                                /*069253*/
 
             ENDJRNPF   FILE(SDPLCSPD)                                /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*S01486*/
                                                                      /*S01486*/
             ENDJRNPF   FILE(SDLBCSPD)                                /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*S01486*/
                                                                      /*S01486*/
             ENDJRNPF   FILE(SDPATTPD)                                /*146350*/
             MONMSG     MSGID(CPF0000)                                /*146350*/
                                                                      /*146350*/
             ENDJRNPF   FILE(SDJUSRPD)                                /*146350*/
             MONMSG     MSGID(CPF0000)                                /*146350*/
                                                                      /*146350*/
             ENDJRNPF   FILE(SDRELCPD)                                /*146350*/
             MONMSG     MSGID(CPF0000)                                /*146350*/
                                                                      /*146350*/
             ENDJRNPF   FILE(SDCCRDPD)                                /*146350*/
             MONMSG     MSGID(CPF0000)                                /*146350*/
                                                                      /*146350*/
             ENDJRNPF   FILE(SDKYCIPD)                                                    /*CSD028*/
             MONMSG     MSGID(CPF0000)                                                    /*CSD028*/
                                                                                          /*CSD028*/
             DLTJRN     JRN(SD0013JRN)
             MONMSG     MSGID(CPF0000)
 
/* Change job to automatically reply to the journal receiver not */
/* fully saved message.                                          */
 
             CHGJOB     INQMSGRPY(*DFT)
 
             DLTJRNRCV  JRNRCV(SD0013RCV)
             MONMSG     MSGID(CPF0000)
 
/* Change job to reply required again */
 
             CHGJOB     INQMSGRPY(*RQD)
 
/* Setup journal environment and start journalling */
 
/************CRTJRNRCV  JRNRCV(&XLIB/SD0013RCV) TEXT('Journal +   */  /*077335*/
/************             receiver for SD0013 background updates')*/  /*077335*/
                                                                      /*077335*/
/************CRTJRN JRN(&XLIB/SD0013JRN) JRNRCV(&XLIB/SD0013RCV) +*/  /*077335*/
/************             TEXT('SD0013 temporary journal')        */  /*077335*/
                                                                      /*077335*/
             CRTJRNRCV  JRNRCV(&JLIB/SD0013RCV) TEXT('Journal +
                          receiver for SD0013 background updates')    /*077335*/
                                                                      /*077335*/
             CRTJRN     JRN(&JLIB/SD0013JRN) JRNRCV(&JLIB/SD0013RCV) +
                          TEXT('SD0013 temporary journal')            /*077335*/
 
/************STRJRNPF FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +  /*069253*/
/************             FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +  /*069253*/
/************             SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD +       /*069253*/
/************             SDFCTLPA) JRN(SD0013JRN) IMAGES(*BOTH) +    /*069253*/
/************             OMTJRNE(*OPNCLO)*/                          /*069253*/
                                                                      /*069253*/
/**********  STRJRNPF   FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +/*S01486*/
/**********               FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +  /*S01486*/
/**********               SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD +       /*S01486*/
/**********               SDFCTLPA SDCBRTPD PTYHSTPD) +               /*S01486*/
/**********               JRN(SD0013JRN) IMAGES(*BOTH) +              /*S01486*/
/**********               OMTJRNE(*OPNCLO)                 /*069253*/ /*S01486*/
 
/**********  STRJRNPF   FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +
/**********               FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +
/**********               SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD +
/**********               SDFCTLPA SDCBRTPD PTYHSTPD SDPLCSPD +
/**********               SDLBCSPD) JRN(SD0013JRN) IMAGES(*BOTH) +
/**********               OMTJRNE(*OPNCLO)                 /*S01486*/ /*146350*/
 
/**********  STRJRNPF   FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +                    /*CSD028*/
/**********               FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +                      /*CSD028*/
/**********               SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD +                           /*CSD028*/
/**********               SDFCTLPA SDCBRTPD PTYHSTPD SDPLCSPD +                           /*CSD028*/
/**********               SDLBCSPD SDPATTPD SDJUSRPD SDRELCPD +                           /*CSD028*/
/**********               SDCCRDPD) JRN(SD0013JRN) IMAGES(*BOTH) +                        /*CSD028*/
/**********               OMTJRNE(*OPNCLO)                            /*146350*/          /*CSD028*/
                                                                                          /*CSD028*/
             STRJRNPF   FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +
                          FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +
                          SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD +
                          SDFCTLPA SDCBRTPD PTYHSTPD SDPLCSPD +
                          SDLBCSPD SDPATTPD SDJUSRPD SDRELCPD +
                          SDCCRDPD SDKYCIPD) JRN(SD0013JRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                                                /*CSD028*/
                                                                                          /*CSD028*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SDC0013002                                          */
 
/* Call customer deletion program */
 
             CALL       PGM(SD0013) PARM(&RSEQ &RLVL &RENT)
 
/* Check switches after call to SD0013 */
 
             RTVJOBA    SWS(&SWS)
 
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(DO)
 
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
 
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&LDA) +
                             TOMSGQ(MOPERQ)
 
                GOTO       CMDLBL(ABNOR)
 
             ENDDO
 
/* Commit changes */
 
             COMMIT
 
/* Avoid ABNOR processing */
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination processing */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             ROLLBACK
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('Program SDC0013 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
/* End of program processing */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* Close down SD0011X, SD0010U and SD0340U */                         /*077335*/
                                                                      /*077335*/
             CALL       PGM(SD0011X) PARM(&RTNCDE &CUST &RTNCDE2 +
                          &STRING1 &STRING2 &STRING3 &STRING4 +
                          &STRING5 'L')                               /*077335*/
                                                                      /*077335*/
                                                                      /*077335*/
/* End journalling and commitment control */
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,SDC0013006                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/************ENDJRNPF FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +  /*069253*/
/************            FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +   /*069253*/
/************            SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD SDFCTLPA)/*069253*/
                                                                      /*069253*/
/**********  ENDJRNPF   FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +/*S01486*/
/**********               FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +  /*S01486*/
/**********               SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD +       /*S01486*/
/**********               SDFCTLPA SDCBRTPD PTYHSTPD)      /*069253*/ /*S01486*/
/**********                                                           /*S01486*/
/**********  ENDJRNPF   FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +
                          FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +
                          SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD +
                          SDFCTLPA SDCBRTPD PTYHSTPD SDPLCSPD +
                          SDLBCSPD)                        /*S01486*/ /*146350*/
 
             ENDJRNPF   FILE(CLINTCA CLINTCB CLINTCC CLINTC1 CLINTSE +
                          FOCLTA FOCLTD SDCUSTPD SDALTNPD SDACUSPD +
                          SDCFCDPD SDCMRKPD SDFOCSPD SDSECSPD +
                          SDFCTLPA SDCBRTPD PTYHSTPD SDPLCSPD +
                          SDLBCSPD SDPATTPD SDJUSRPD SDRELCPD +
                          SDCCRDPD)                                   /*146350*/
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,SDC0013003                                          */
 
/* If this is a successful completion of the program then */
/* delete the journal/journal receiver                    */
 
             IF         COND(%SST(&SWS 7 2) *EQ '00') THEN(DO)
 
                DLTJRN     JRN(SD0013JRN)
                MONMSG     MSGID(CPF0000)
 
/* Change job to automatically reply to the journal receiver not */
/* fully saved message.                                          */
 
                CHGJOB     INQMSGRPY(*DFT)
 
                DLTJRNRCV  JRNRCV(SD0013RCV)
                MONMSG     MSGID(CPF0000)
 
/* Change job to reply required again */
 
                CHGJOB     INQMSGRPY(*RQD)
 
             ENDDO
/*/COPY WNCPYSRC,SDC0013007                                          */
 
             ENDDO                                                    /*CCB009*/
             ENDPGM
