/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Merge message file control program')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0795 - Merge Message File Control Program.               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CUP006             Date 03Feb00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002             Date 15Apr99              */
/*                      CUP004 *CREATE     Date 08Jun98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CUP006 - Change library default to the Bridge ICD file.     */
/*       CUP002 - Change library default to the _DTA library.        */
/*       CUP004 - Make upgrade of DTALIB items easier                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGFNAME)
 
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&MSGFNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&PTFDTA) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*CUP033*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                  /*CUP033*/
             DCL        VAR(&AORTN) TYPE(*CHAR) LEN(7)                                    /*CUP033*/
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                                 /*CUP006*/
/**COPY*UPCPYSRC,UPLIBDCL*                                           */ /*             */ /*CUP033*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                                          /*CUP006*/
/************DCLF       FILE(UPUICDPD)                                      */ /*CUP006*/ /*CUP024*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
                                                                                          /*CUP006*/
/************RCVF                                                           */ /*CUP006*/ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
 
/**COPY*UPCPYSRC,UPLIBNAME**                                         */                   /*CUP006*/
                                                                                          /*CUP006*/
/* Check if all relevant fields have been entered in ICD */                               /*CUP006*/
/**********  IF         COND(&PTFDTA *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CUP033*/
/**********               THEN(DO)                                          */ /*CUP006*/ /*CUP033*/
             CALL       PGM(AOSVALR0) PARM(&AORTN +
                          'BrgMidasSystemPrefix' &SVAL1 +
                          'BrgDeliveredDtaLib' &SVAL2 ' ' ' ' ' ' ' +
                          ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' +
                          ' ' ' ')                                                        /*CUP033*/
             IF         COND(&AORTN *NE '       ') THEN(DO)                               /*CUP033*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CUP006*/
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                      /*CUP006*/
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CUP006*/
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                      /*CUP006*/
/**********     CALL       PGM(SCC0010) PARM('UPC2000' 'ENTER' ' ')         */ /*CUP006*/ /*CUP033*/
                CALL       PGM(SCC0010) PARM('UPC0795' 'ENTER' ' ')                       /*CUP033*/
                GOTO       CMDLBL(END)                                                    /*CUP006*/
             ENDDO                                                                        /*CUP006*/
             ELSE       CMD(DO)                                                           /*CUP033*/
                CHGVAR     VAR(&SBSID) VALUE(%SST(&SVAL1 1 2))                            /*CUP033*/
                CHGVAR     VAR(&PTFDTA) VALUE(%SST(&SVAL2 1 10))                          /*CUP033*/
             ENDDO                                                                        /*CUP033*/
                                                                                          /*CUP006*/
             CHGVAR     VAR(&DTALIB) VALUE(&SBSID *TCAT 'DTALIB')                         /*CUP006*/
 
             DLTMSGF    MSGF(QTEMP/&MSGFNAME)
             MONMSG     MSGID(CPF0000)
 
             CRTMSGF    MSGF(QTEMP/&MSGFNAME) TEXT('Replaced message +
                          identifiers')
 
/********* ? MRGMSGF  ??FROMMSGF(MDB2I__EXT/&MSGFNAME) + **/                              /*CUP002*/
/*********              ??TOMSGF(&DTALIB/&MSGFNAME) +    **/                              /*CUP002*/
/*********              ?*RPLMSGF(QTEMP/&MSGFNAME) +     **/                              /*CUP002*/
/*********              ?*SELECT(*ALL) ?*OMIT(*N)        **/                              /*CUP002*/
/********* ? MRGMSGF  ??FROMMSGF(MDB2I__DTA/&MSGFNAME) +                                  /*CUP006*/
/*********              ??TOMSGF(&DTALIB/&MSGFNAME) +                                     /*CUP006*/
/*********              ?*RPLMSGF(QTEMP/&MSGFNAME) +                                      /*CUP006*/
/*********              ?*SELECT(*ALL) ?*OMIT(*N)                              /*CUP002*/ /*CUP006*/
           ? MRGMSGF  ??FROMMSGF(&PTFDTA/&MSGFNAME) +
                        ??TOMSGF(&DTALIB/&MSGFNAME) +
                        ?*RPLMSGF(QTEMP/&MSGFNAME) +
                        ?*SELECT(*ALL) ?*OMIT(*N)                                         /*CUP006*/
             MONMSG     MSGID(CPF6801) EXEC(GOTO CMDLBL(END))
 
             WRKMSGF    MSGF(QTEMP/&MSGFNAME)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('UPC0795 +
                          ended abnormally - see joblog') +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
