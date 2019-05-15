/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Customer exchanges input')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - RETAIL MODULE                               */
/*                                                                   */
/*       REC0150 - CUSTOMER EXCHANGE INPUT                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE020             Date 20Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB002             Date 18Jul96              */
/*                      054807             DATE 06DEC95              */
/*                      S01408             DATE 05JUN95              */
/*                      S01413             DATE 13APR93              */
/*                      E23060                  08AUG90              */
/*                      S01117                  19MAR90              */
/*                      S01194                  09MAR90              */
/*                      E81175                  26JAN87              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CCB002  -  COB Performance Enhancements                     */
/*                  Access now via access object                     */
/*                  RE0150 now uses an access object for update.     */
/*                  Override to MEMO removed.                        */
/*       054807 - Set off U7/U8 at beginning, to avoid spurious      */
/*                error messages.                                    */
/*       S01408 - Addition of core hooks REC0150MPS                  */
/*                                       REC0150MP1                  */
/*       S01413 - Retail 3 Incorporation.                            */
/*       E23060 - RESET JOB SWITCH 8 AT START OF EACH CYCLE          */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01194 - NEW STANDING DATA                                  */
/*       E81175 - BLANK MESSAGE SENT TO SCREEN AT END OF PROGRAM     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CRE020*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                    /*CRE020*/
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC0150MPS                                           /*S01408*/
/**/                                                                  /*S01408*/
/************CHGJOB     SWS(XXXXXXX0)                 /*E21177 054807*/
             CHGJOB     SWS(XXXXXX00)                        /*054807*/
                                                                                          /*CRE020*/
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE020*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CRE020*/
             CHGVAR     VAR(&PSARD) VALUE('CRE020')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
                                                                                          /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&PRTCD *EQ '       ') THEN(DO)                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&PRTCD *NE '*NRF   ' *AND +
                     &PRTCD *NE '       ') THEN(DO)                                       /*CRE020*/
             DMPCLPGM                                                                     /*CRE020*/
             GOTO       CMDLBL(END)                                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC0150MP1                                           /*S01408*/
/**/                                                                  /*S01408*/
/************OVRDBF FILE(TABLE) TOFILE(TABRE2)                       * *S01194*/
/************OVRDBF FILE(MEMO) TOFILE(MEMOS)                          /*CCB002*/
/**/
             CALL PGM(RE0150)
/**/
/*/COPY WNCPYSRC,REC0150001                                          */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
/************DLTOVR FILE(*ALL)                                        /*CCB002*/
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                      /*S01117*/
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)               /*S01117*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01117*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01117*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)                                /*S01117*/
             ENDDO                                                    /*S01117*/
/*********** IF COND(*NOT %SWITCH(XXX00000)) THEN(DO) ***************  *E81175*/
/**/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   CHGVAR VAR(&MSG) VALUE('JOB TERMINATED - DATABASE IN ERROR')
                   ROLLBACK
/***************ENDDO************************************************  *E81175*/
/**/
                SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INFO)
             ENDDO
                                                                                          /*CRE020*/
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                        *CAT '''RE0150'' ''RE''' *CAT ')')                                /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
/**/
 ENDPGM:     RCLRSC                                                   /*S01117*/
/*NDPGM:     ENDPGM                                                   /*S01117*/
END:                                                                                      /*CRE020*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
