/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Prompt for database restore')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1060 - Prompt for database restore                       */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CBF012             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 08Jun06              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 09Jun05              */
/*                      CPK017             Date 05Nov03              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CBF012 - BF Infrastructure: Upgradability                   */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Change to use system values.                       */
/*       CPK017 - Midas Plus implementation.                         */
/*                Add new parameter &PROCESS.                        */
/*                If GP, retrieve &GPSBSID from SDSVALPD.            */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CPK017*/
             PGM        PARM(&PROCESS)                                                    /*CPK017*/
 
/**COPY*UPCPYSRCG,UPGSVALDCL*                                        */ /*             */ /*CUP033*/
             DCL        VAR(&PROCESS) TYPE(*CHAR) LEN(7)                                  /*CPK017*/
 
             DCL        VAR(&DEVD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&BRGLIBSVAL) TYPE(*CHAR) LEN(20) +
                          VALUE('BrgDeliveredBrgLib')                                     /*CUP033*/
             DCL        VAR(&GPFXSVAL) TYPE(*CHAR) LEN(20) +
                          VALUE('BrgMidasGlobalPrefix')                                   /*CUP033*/
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20) +
                          VALUE('BrgMidasSystemPrefix')                                   /*CUP033*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/**COPY*UPCPYSRCG,UPGSVALCL1*                                        */ /*             */ /*CUP033*/
/**********  IF         COND(&PTFUPG *EQ ' ') THEN(DO)                                 */ /*CUP033*/
/**Set*up*messages*for*Midas*Information*Screen***/ /*                                 */ /*CUP033*/
/**********     RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                   */ /*CUP033*/
/**********     CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                   */ /*CUP033*/
/**********     RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                   */ /*CUP033*/
/**********     CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                   */ /*CUP033*/
/**********     CALL       PGM(SCC0010) PARM('SMC1060' 'ENTER' ' ')                    */ /*CUP033*/
/**********     GOTO       CMDLBL(END)                                                 */ /*CUP033*/
/**********  ENDDO                                                                     */ /*CUP033*/
 
DEVICENAME:
             ?          DEVICENAME
             MONMSG     MSGID(CPF6801) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
             RTVDTAARA  DTAARA(QTEMP/DEVD) RTNVAR(&DEVD)
 
/* Check device is valid. */
             CHKOBJ     OBJ(&DEVD) OBJTYPE(*DEVD)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE('Device' +
                             *BCAT &DEVD *BCAT 'does not exist.')
                CALL       PGM(SCC0010) PARM('SMC1060' 'ENTER' ' ')
                GOTO       CMDLBL(DEVICENAME)
             ENDDO
 
/**********  CALL       PGM(SMC1061) PARM(&DEVD &PTFUPG)                               */ /*CPK017*/
/**********  CALL       PGM(SMC1061) PARM(&DEVD &PTFUPG &PROCESS)           */ /*CPK017*/ /*CSM003*/
             IF         COND(&PROCESS *EQ '*GLOBAL') THEN(DO)                             /*CSM003*/
/**********     CALL       PGM(SMC1061) PARM(&DEVD &PTFUPG)                 */ /*CSM003*/ /*CUP033*/
                CALL       PGM(SMC1061) PARM(&DEVD &BRGLIBSVAL &GPFXSVAL)                 /*CUP033*/
             ENDDO                                                                        /*CSM003*/
             IF         COND(&PROCESS *EQ '*ZONE') THEN(DO)                               /*CSM003*/
/**********     CALL       PGM(SMC001061) PARM(&DEVD &PTFUPG)               */ /*CSM003*/ /*CUP033*/
/**********     CALL       PGM(SMC001061) PARM(&DEVD &BRGLIBSVAL &PFXSVAL) */  /*CUP033*/ /*CBF012*/
                CALL       PGM(SMC001061) PARM(&DEVD &BRGLIBSVAL +
                          &PFXSVAL &GPFXSVAL)                                             /*CBF012*/
             ENDDO                                                                        /*CSM003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal end. */
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC1060') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC1060' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
