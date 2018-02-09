/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Check whether specified ASP exist')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*       SDCHKASP - CHECK IF ASP EXISTS                             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       WRITTEN FOR S01173 - USER SPECIFIED ASP FOR JRN/JRNRCV     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      069393             Date 05May94              */
/*                      E29436             DATE  11OCT91            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC043 - MidasPlus IASP Enablement                         */
/*  069393 - CHANGE CRTSAVF CMD TO BE AS/400 NOT S/38.              */
/*         - CREATE LIBRARY QTEMPMIDAS INSTEAD OF USING QTEMP AS    */
/*           THE LIBRARY MUST BE IN THE SAME ASP AS THE SAVE FILE.  */
/*       E29436 - MOVE TO SCCLSRC FROM RR.                          */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ASP &RTNCDE)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*           DECLARE VARIABLES                                       */
/**/
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCDE) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/**/
/*           EXECUTABLE CODE                                         */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO ERROR)
/**/
/*           IF ASP IS 01 IT MUST EXIST. NO FURTHER PROCESSING       */
/**/
             IF         COND(&ASP = '01') THEN(RETURN)
/* */                                                                 /*069393*/
/*                                                                                        /*CSC043*/
/** Get the global IASP system values */                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 +
                          'IASPgroup' &SVAL2 &SVALK3 +
                          &SVAL3 &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                          &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                          &SVAL8 &SVALK9 &SVAL9 &SVALK10 &SVAL10)                         /*CSC043*/
/*                                                                                        /*CSC043*/
/** Check whether system is in IASP environment. */                                       /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                            /*CSC043*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
/*                                                                                        /*CSC043*/
/** Get name of IASP. */                                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                              /*CSC043*/
                                                                                          /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTLIB     LIB(QTEMPMIDAS) ASP(&IASP)                                        /*CSC043*/
             MONMSG     MSGID(CPF7012) EXEC(DO)                                           /*CSC043*/
                CHGVAR     VAR(&RTNCDE) VALUE(9)                                          /*CSC043*/
                RETURN                                                                    /*CSC043*/
                ENDDO                                                                     /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTLIB     LIB(QTEMPMIDAS) ASP(&ASP)                     /*069393*/
             MONMSG     MSGID(CPF7012) EXEC(DO)                       /*069393*/
                CHGVAR     VAR(&RTNCDE) VALUE(9)                      /*069393*/
                RETURN                                                /*069393*/
                ENDDO                                                 /*069393*/
             ENDDO                                                                        /*CSC043*/
/**/
/*           OTHERWISE TRY TO CREATE SAVE FILE IN ASP                */
/**/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(QTEMPMIDAS/SAVF) ASP(&IASP)                                  /*CSC043*/
             MONMSG     MSGID(CPF7302) EXEC(DO)                                           /*CSC043*/
                CHGVAR     VAR(&RTNCDE) VALUE(9)                                          /*CSC043*/
                DLTLIB     LIB(QTEMPMIDAS)                                                /*CSC043*/
                RETURN                                                                    /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
/************CRTSAVF    FILE(SAVF.QTEMP) ASP(&ASP)                      069393*/
             CRTSAVF    FILE(QTEMPMIDAS/SAVF) ASP(&ASP)               /*069393*/
             MONMSG     MSGID(CPF7302) EXEC(DO)
                CHGVAR     VAR(&RTNCDE) VALUE(9)
                DLTLIB     LIB(QTEMPMIDAS)                            /*069309*/
                RETURN
             ENDDO
             ENDDO                                                                        /*CSC043*/
/************DLTF       FILE(SAVF.QTEMP)                                069393*/
             DLTF       FILE(QTEMPMIDAS/SAVF)                         /*069393*/
             MONMSG     MSGID(CPF0000)
             DLTLIB     LIB(QTEMPMIDAS)                               /*069393*/
             MONMSG     MSGID(CPF0000)                                /*069393*/
             RETURN
/**/
/*           ERROR. BAD RETURN                                       */
/**/
ERROR:       CHGVAR     VAR(&RTNCDE) VALUE(9)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
