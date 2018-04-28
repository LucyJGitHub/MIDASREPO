/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Set all status fields to blank')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0021 - Set all status fields to blank                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CPK018             Date 23Feb04              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002             Date 28Apr99              */
/*                      CUP001 *CREATE     Date 20Jan98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK018 - MidasPlus packaging.  Remove CHKLIBLE processing.  */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CUP002 - Set library list correctly.                        */
/*       CUP001 - Create utility to reset status fields              */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&BRGSVAL)                                                    /*CUP033*/
 
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRCG,UPGSVALDCL*                                        */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*CUP002*/
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
             DCLF       FILE(UPGSVALJ0)                                                   /*CUP033*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/************RCVF                                                           */ /*CUP002*/ /*CUP024*/
/**COPY*UPCPYSRCG,UPGSVALCL1*                                        */ /*  */ /*CUP024*/ /*CUP033*/
                                                                      /*CUP002*/
/**CHKLIBLE:                                                                */ /*CUP002*/ /*CPK018*/
/**********  CHGVAR     VAR(&RETURN) VALUE(' ')                             */ /*CUP002*/ /*CPK018*/
/**********  CHKLIBLE   LIBS(&PTFUPG) RETURN(&RETURN)                       */ /*CUP002*/ /*CPK018*/
/**********  IF         COND(&RETURN *EQ 'F') THEN(DO)                      */ /*CUP002*/ /*CPK018*/
/**********     EDTLIBL                                                     */ /*CUP002*/ /*CPK018*/
/**********     GOTO CHKLIBLE                                               */ /*CUP002*/ /*CPK018*/
/**********  ENDDO                                                          */ /*CUP002*/ /*CPK018*/
                                                                      /*CUP002*/
 
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
/**********     GOTO       CMDLBL(CHECK)                                    */ /*CUP033*/ /*CPK029*/
             ENDDO                                                                        /*CUP033*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                   RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                   /*CUP033*/
                   CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                   /*CUP033*/
                   RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                   /*CUP033*/
                   CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                   /*CUP033*/
                   CALL       PGM(SCC0010) PARM('UPC0021' 'ENTER' ' ')                    /*CUP033*/
                   GOTO       CMDLBL(END)                                                 /*CUP033*/
                ENDDO                                                                     /*CUP033*/
 
             RMVLIBLE   LIB(&PTFUPG)                                  /*CUP002*/
             MONMSG     MSGID(CPF0000)                                /*CUP002*/
             ADDLIBLE   LIB(&PTFUPG)                                  /*CUP002*/
RETRY:
READNEXT:
             OVRDBF     FILE(UPDLVC) TOFILE(*LIBL/UPDLVCPD)
             CALL       PGM(UP0021) PARM(' ')
             DLTOVR     FILE(UPDLVC)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Error handling brought in through /COPY */
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                RTVMSG    MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(UPC0021) +
                          MSG(&MESSAGE)
/*/COPY UPCPYSRCG,C_UPERRA                                           */
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
