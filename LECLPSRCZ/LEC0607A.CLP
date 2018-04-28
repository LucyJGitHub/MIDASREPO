/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE INTEREST ACCRUALS REPORT')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0607A - INTEREST ACCRUALS REPORT                        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. BHF798            DATE  09OCT90             */
/*       PREV AMEND NO. BHF742            DATE  02OCT90             */
/*                      S01117            DATE  08FEB90             */
/*                      S01194            DATE  08FEB90             */
/*                                                                  */
/********************************************************************/
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       BHF742 - SHOULD CLOSE FILE OPENED TO CHECK FILE POSITIONING*/
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RENT)                                    /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('INTEREST ACCRUALS REPORT ')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/**/
/* CLEAR FILES FOR LE0640 */
             CLRPFM     FILE(IACEXHH)
             CLRPFM     FILE(IACEXDP)
             CLRPFM     FILE(IACEXZZ)
/**/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
/**/
/* INTEREST ACCRUALS EXTRACT                                        */
             CALL PGM(LE0640)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
/************   OVRDBF     FILE(TABLED) TOFILE(TABLEEE) SHARE(*NO)*/  /*S01194*/
/**/
/* INTEREST ACCRUALS REPORT                                         */
/************** CALL PGM(LE0650)                                     * *S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(INACS) POSITION(*KEY 1 IACEXDPF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(INACS) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(INACS)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(INACS)                                  /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
                CALL PGM(LE0650) PARM(&RSEQ &RENT)                    /*S01117*/
/**/
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/* PF/IACEX&& FILES ARE OUTPUT FROM LE0640 AND USED IN LE0650       */
                   CLRPFM     FILE(IACEXHH)
                   CLRPFM     FILE(IACEXDP)
                   CLRPFM     FILE(IACEXZZ)
                ENDDO
/**/
             ENDDO
/**/
/**/
/********    DLTOVR     FILE(*ALL)                           */       /*S01194*/
             CLOF       OPNID(INACS)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
