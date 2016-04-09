/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Review reports (part 2)')                    */
/*OVR  : OVRDBF FILE(TMPSPLF) TOFILE(FCTMPPD)                       :*/
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0260 - GET SPOOL FILE ATTRIBUTES                          */
    /*                                                               */
/*       (c) Misys International Banking Systems Ltd. 2001           */
    /*                                                               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       LAST AMEND NO. LN0851           DATE 12OCT90            */
    /*       PREV AMEND NO. LN0848           DATE 10OCT90            */
    /*                      LN0736           DATE 12SEP90            */
    /*                      LN0405           DATE 20JUN90            */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*       LN0851 - CORRECT MESSAGE HANDLING.                      */
    /*                ADD REPORT REQUEST NUMBER TO ERROR MESSAGE.    */
    /*                RETRIEVE OUTQ FOR DISPLAY.                     */
    /*       LN0848 - HOLD THE SPOOL FILE PRODUCED BY WRKSPLFA.      */
    /*       LN0736 - CHANGES TO ERROR FLAGS AND MONITOR MESSAGES    */
    /*                RE SPOOL FILE HANDLING                         */
    /*       LN0405 - WRONG POSITIONS SPECIFIED FOR SPOOL FILE       */
    /*                ATTRIBUTES. ALSO MOVE FILE DELETION AROUND     */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*  THIS PROGRAM WILL OBTAIN THE STATUS OF THE PRINTED           */
    /*  OUTPUT FROM THE SPOOL FILE ATTRIBUTES AND RETURN TO          */
    /*  THE CALLING RPG PROGRAM: (FC0065)                            */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
/************PGM        PARM(&SPLF &JNUM &USR &JNAM &SNUM &HOLD &SAVE +
                          &CPYS &ERR)                                 /*LN0851*/
             PGM        PARM(&SPLF &JNUM &USR &JNAM &SNUM &REQN &HOLD +
                          &SAVE &CPYS &OUTQ &ERR)                     /*LN0851*/
             DCL        VAR(&SPLF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)                /*LN0851*/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SNUM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REQN) TYPE(*CHAR) LEN(5)                 /*LN0851*/
             DCL        VAR(&RCDH) TYPE(*CHAR) LEN(132)
             DCL        VAR(&RCDS) TYPE(*CHAR) LEN(132)
             DCL        VAR(&RCDC) TYPE(*CHAR) LEN(132)
             DCL        VAR(&RCDO) TYPE(*CHAR) LEN(132)               /*LN0851*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)                /*LN0736*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)                /*LN0736*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*LN0736*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*LN0736*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(QTEMP/TMPSPLF)
/************MONMSG     MSGID(RPG0000) EXEC(GOTO CMDLBL(ABNOR))      * *LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*LN0736*/
    /*                                                               */
             CHGJOB     SWS(00000000)
    /**                                                            * */
             CLOF       OPNID(TMPSPLF)                                /*LN0405*/
             MONMSG MSGID(CPF4520)                                    /*LN0405*/
    /**                                                                *LN0405*/
             DLTF       FILE(QTEMP/TMPSPLF)                           /*LN0405*/
             MONMSG     MSGID(CPF2105 CPF3220)                        /*LN0405*/
    /*                                                               */
    /* Display spool file attributes to a printer file, +
    /* if file not found -terminate processing                       */
/**********  WRKSPLFA   FILE(&SPLF) JOB(&JNUM/&USR/&JNAM) +     ***/
/**********               SPLNBR(*LAST) OUTPUT(*PRINT)          ***/
             OVRPRTF    FILE(QPDSPSFA) HOLD(*YES)                     /*LN0848*/
             WRKSPLFA   FILE(&SPLF) JOB(&JNUM/&USR/&JNAM) +
                          SPLNBR(&SNUM) OUTPUT(*PRINT)
/************MONMSG     MSGID(CPF3303 CPF3344 CPF3342) EXEC(DO)      * *LN0736*/
/************CHGVAR     VAR(&ERR) VALUE('Y')                         * *LN0736*/
/************GOTO       CMDLBL(THEEND)                               * *LN0736*/
/************MONMSG     MSGID(CPF3336) EXEC(DO)                /*LN0736*LN0851*/
             MONMSG     MSGID(CPF3309 CPF3336 CPF3342 CPF3344) +
                          EXEC(DO)                                    /*LN0851*/
                CHGVAR     VAR(&ERR) VALUE('P')                       /*LN0736*/
                GOTO       CMDLBL(THEEND)                             /*LN0851*/
/************   RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)     /*LN0736*LN0851*/
/************   SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                                                               /*LN0736*LN0851*/
/************   SNDPGMMSG  MSG('FCC0260 Get Spool File Attributes +
                             unable to process spool file.  See +
                             previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                    /*LN0736*LN0851*/
                ENDDO                                                 /*LN0736*/
    /*                                                               */
/*      Clear file:TEMPSPLF In Library:QTEMP                         */
             DLTF       FILE(QTEMP/TEMPSPLF)
             MONMSG MSGID(CPF2105)
    /*                                                               */
             CRTPF      FILE(QTEMP/TEMPSPLF) RCDLEN(132) SHARE(*YES) +
                          LVLCHK(*NO)
             CPYSPLF    FILE(QPDSPSFA) TOFILE(QTEMP/TEMPSPLF) +
                          SPLNBR(*LAST)
    /*                                                               */
    /**                                                            * */
             CPYF       FROMFILE(QTEMP/TEMPSPLF) +
                          TOFILE(QTEMP/TMPSPLF) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FROMRCD(11) TORCD(11) +
                          FMTOPT(*NOCHK)
             MONMSG MSGID(CPF2817)                                    /*LN0851*/
             CPYF       FROMFILE(QTEMP/TEMPSPLF) +
                          TOFILE(QTEMP/TMPSPLF) MBROPT(*ADD) +
                          CRTFILE(*NO) FROMRCD(15) TORCD(16) +
                          FMTOPT(*NOCHK)
             MONMSG MSGID(CPF2817)
             CPYF       FROMFILE(QTEMP/TEMPSPLF) +
                          TOFILE(QTEMP/TMPSPLF) MBROPT(*ADD) +
                          CRTFILE(*NO) FROMRCD(6) TORCD(6) +
                          FMTOPT(*NOCHK)                              /*LN0851*/
             MONMSG MSGID(CPF2817)                                    /*LN0851*/
             RCVF
/*********** CHGVAR     VAR(&RCDC) VALUE(TMPSPLF)              ***/   /*LN0405*/
             CHGVAR     VAR(&RCDC) VALUE(&TMPSPLF)                    /*LN0405*/
    /*                                                               */
             RCVF
/*********** CHGVAR     VAR(&RCDH) VALUE(TMPSPLF)              ***/   /*LN0405*/
             CHGVAR     VAR(&RCDH) VALUE(&TMPSPLF)                    /*LN0405*/
    /*                                                               */
             RCVF
/*********** CHGVAR     VAR(&RCDS) VALUE(TMPSPLF)              ***/   /*LN0405*/
             CHGVAR     VAR(&RCDS) VALUE(&TMPSPLF)                    /*LN0405*/
    /*                                                               */
             RCVF                                                     /*LN0851*/
             CHGVAR     VAR(&RCDO) VALUE(&TMPSPLF)                    /*LN0851*/
    /*                                                               */
/*********** CHGVAR     VAR(&CPYS) VALUE(%SST(&RCDC 46 4))     ***/   /*LN0405*/
             CHGVAR     VAR(&CPYS) VALUE(%SST(&RCDC 47 4))            /*LN0405*/
    /*                                                               */
/*********** CHGVAR     VAR(&HOLD) VALUE(%SST(&RCDH 47 1))     ***/   /*LN0405*/
             CHGVAR     VAR(&HOLD) VALUE(%SST(&RCDH 48 1))            /*LN0405*/
    /*                                                               */
/*********** CHGVAR     VAR(&SAVE) VALUE(%SST(&RCDS 47 1))    ***/    /*LN0405*/
             CHGVAR     VAR(&SAVE) VALUE(%SST(&RCDS 48 1))            /*LN0405*/
    /*                                                               */
             CHGVAR     VAR(&OUTQ) VALUE(%SST(&RCDO 47 10))           /*LN0851*/
    /**                                                            * */
/*********** DLTF       FILE(QTEMP/TMPSPLF)                   ***/    /*LN0405*/
/*********** MONMSG     MSGID(CPF2105 CPF3220)                ***/    /*LN0405*/
/*********** DLTSPLF    FILE(QPDSPSFA) JOB(&JNUM/&USR/&JNAM) + ***/   /*LN0405*/
/***********              SPLNBR(*LAST)                        ***/   /*LN0405*/
    /**                                                           **/ /*LN0405*/
             DLTSPLF    FILE(QPDSPSFA) JOB(*) SPLNBR(*LAST)           /*LN0405*/
    /**                                                           **/ /*LN0405*/
/************MONMSG     MSGID(CPF3303 CPF3309 CPF3344)               * *LN0736*/
             GOTO       CMDLBL(THEEND)
    /*                                                               */
    /*                                                              */
/**ABNOR:     SNDPGMMSG  MSG('R.C.F Input cycle initiation - +  **/   /*LN0405*/
/**********               Terminated Abnormally') TOPGMQ(*EXT) + */   /*LN0405*/
/**********               TOMSGQ(MOPERQ MRUNQ)                  **/   /*LN0405*/
/**ABNOR:****CHGVAR     VAR(&ERR) VALUE('F')                 /*LN0405* *LN0736*/
/************MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +           * *LN0736*/
/************             CMDLBL(THEEND))                            * *LN0736*/
 ABNOR:      CHGVAR     VAR(&ERR) VALUE('Y')                          /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)               /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
/************SNDPGMMSG  MSG('FCC0260 Get Spool File Attributes +
/************             terminated abnormally.  See previous +
/************             messages for further information.') +
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)          /*LN0736*LN0851*/
             SNDPGMMSG  MSG('FCC0260 Get Spool File Attributes +
                          terminated abnormally for Report +
                          Request Number ' *CAT &REQN *CAT +
                          '.  See previous +
                          messages for further information.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*LN0851*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
 THEEND:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
