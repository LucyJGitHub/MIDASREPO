/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE T&N Accounts - Feature Initialisation')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail T&N Accounts                                 */
/*                                                                   */
/*       SDCCRE015 - Feature Initialisation                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. 237781             Date 25Jan06              */
/*       Prev Amend No. 237976             Date 25Jan06              */
/*                      CRE015  *CREATE    Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       237781 - No interest capitalisation on some T&N accounts.   */
/*       237976 - Ensure next cap dates on ACCNTAB match REPRPNPD    */
/*       CRE015 - Retail Term and Notice Accounts                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1) VALUE('Y')                        /*237781*/
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)                            /*237781*/
             MONMSG     MSGID(CPF0000)                                                    /*237781*/
 
/* If commitment control already active, then don't end it later*/                        /*237781*/
 
             STRCMTCTL  LCKLVL(*CHG)                                                      /*237781*/
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&CMTCTL) +
                          VALUE('N'))                                                     /*237781*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DPLIB)
             CHGVAR     VAR(&DPLIB) VALUE(&DPLIB *TCAT 'DPLIB')
 
/* Prompt to reinitialise files  */
             ?          SDCCRE015
 
/* In case Term & Notice already present as old version */
/* then remove records where E2ITEM <> 1  */
 
             CALL SD0CRE015A
 
/* In case Term & Notice already present as old version */
/* reset next cap dates if they are far in the future */
 
             CALL SD0CRE015B
 
/* Update the Sundry Postings Register file GLRGSUPD */
             CALL RE4038
 
                                                                                          /*237781*/
/* In case Term & Notice already present as old version */                                /*237781*/
/* synchronize next cap dates on ACCNTAB with those on  */                                /*237781*/
/* REPRPNPD                                             */                                /*237781*/
                                                                                          /*237781*/
             CALL RE4019                                                                  /*237781*/
             MONMSG CPF0000 EXEC(CHGJOB SWS(XXXXXX11))                                    /*237976*/
             IF (*NOT %SWITCH(XXXXXX00)) THEN(GOTO ABNORM)                                /*237976*/
             COMMIT                                                                       /*237781*/
             GOTO       CMDLBL(END)                                                       /*237781*/
ABNORM:                                                                                   /*237976*/
             ROLLBACK                                                                     /*237976*/
                                                                                          /*237976*/
END:         IF         COND(&CMTCTL *EQ 'Y') THEN(ENDCMTCTL)                             /*237781*/
                                                                                          /*237781*/
             ENDPGM
