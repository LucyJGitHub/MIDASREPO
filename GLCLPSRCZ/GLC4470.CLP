/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MTCash Narrative File Purge')                   */
/*********************************************************************/
/*                                                                   */
/*     Midas General Ledger Module                                   */
/*                                                                   */
/*       GLC4470 - MTCash Narrative File Purge                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. BUG26444           Date 15Oct09              */
/*                      BUG23742 *CREATE   Date 09May09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG26444 - GLC4470 00001 on MSGW                            */
/*       BUG23742 - Improper handling of Ext Narr from Batch         */
/*                  Interface Input                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare Variables */
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
/* Set off Switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/* Call PGM CB0160, to find out the value of Busy */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
 
/* Setup library name */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
 
/* If this is not a restart then create security copies */
 
/**********  IF         COND(&BUSY *EQ 'N') THEN(DO) */                                 /*BUG26444*/
             IF         COND(&BUSY *NE 'Y') THEN(DO)                                    /*BUG26444*/
 
             DLTF       FILE(&DPLIB/XGLMNARPD)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(&DMLIB/GLMNARPD) +
                        TOFILE(&DPLIB/XGLMNARPD) +
                        MBROPT(*REPLACE) CRTFILE(*YES)
                        MONMSG MSGID(CPF2817) CMPDTA(CPF2869)
 
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y') */                            /*BUG26444*/
             ENDDO
 
/* If this is a restart then copy security copies back to master file */
 
            ELSE       CMD(DO)
 
            CPYF       FROMFILE(&DPLIB/XGLMNARPD) +
                       TOFILE(&DMLIB/GLMNARPD) MBROPT(*REPLACE)
            MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                       EXEC(CLRPFM FILE(&DMLIB/GLMNARPD))
 
            ENDDO
 
/* Change component status to 'Started' */                                              /*BUG26444*/
                                                                                        /*BUG26444*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')                               /*BUG26444*/
                                                                                        /*BUG26444*/
/* Call batch history purge program */
 
             CALL       PGM(GL4470)
 
/* If purge is successful then reorganize master files */
 
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
 
             CPYF       FROMFILE(&DMLIB/GLMNARPD) +
                        TOFILE(QTEMP/GLMNARPDX) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
                        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CALL       PGM(SCC000060) PARM('GLMNARPDX' '*FIRST')
 
             CPYF       FROMFILE(QTEMP/GLMNARPDX) +
                        TOFILE(&DMLIB/GLMNARPD) MBROPT(*REPLACE) +
                        CRTFILE(*NO)
                        MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM FILE(&DMLIB/GLMNARPD))
 
/* Set off the busy flag */
 
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')
 
                 DLTF       FILE(&DPLIB/XGLMNARPD)
                 MONMSG     MSGID(CPF0000)
 
                 ENDDO
 
                 ELSE       CMD(DO)
 
/* Database error routine */
 
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                 ENDDO
 
                 CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                            Misys International Banking Systems Ltd.')
 
                 ENDPGM
