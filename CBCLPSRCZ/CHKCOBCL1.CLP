/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Contrl pgm for checking COB files')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     CLOSE OF BUSINESS PROCESSING UTILITIES            */
/*                                                                   */
/*       CHKCOBCL1   CALL PROGRAM TO VALIDATE COB FILES              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 21Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01417             Date 19Jul93              */
/*                                                                   */
/*********************************************************************/
/*                                                                    /*S01417*/
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Tidy up message.              /*S01417*/
/*       S01417 - Add Parameter to signify 'Files Not Validated'.     /*S01417*/
/*                N.B. Passed from CL Program CBMENUCL                /*S01417*/
/*                             to RPG Program CHKCOBRPG.              /*S01417*/
/*                                                                    /*S01417*/
/*********************************************************************/
/*                                                                   */
/**/
/************PGM                                                      /*S01417*/
             PGM        PARM(&NOTVAL &LIB)                            /*S01417*/
/**/
             DCL        VAR(&NOTVAL) TYPE(*CHAR) LEN(1)               /*S01417*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCLF       FILE(CHKCOBDF)
 
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGJOB     SWS(00000000)
/**/                                                                  /*S01417*/
/* IF THIS PROGRAM IS BEING CALLED FROM OPTION 9 ON THE MENU */       /*S01417*/
/* (NOT AUTOMATICALLY ON EXITING MENU) */                             /*S01417*/
             IF         COND(&LIB *EQ '          ') THEN(DO)          /*S01417*/
/**/
/* SET SCREEN CONDITIONING INDICATOR ON AND DISPLAY SCREEN */
/**/
             CHGVAR     VAR(&IN51) VALUE('1')
             SNDRCVF
             ENDDO                                                    /*S01417*/
 
/* Before copying run program to set statuses to blank. */                                /*CPK018*/
             CALL       PGM(CB000028)                                                     /*CPK018*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CPK018*/
                GOTO       CMDLBL(ABNOR)                                                  /*CPK018*/
             ENDDO                                                                        /*CPK018*/
 
/**/
/* COPY FROM THE COB FILES OF THE REQUESTED */
/* LIBRARY INTO THE CHECKING FILES */
/**/
             CPYF       FROMFILE(&LIB/CBCMPNPD) TOFILE(CHKCMPPD) +
                          MBROPT(*REPLACE)
             CPYF       FROMFILE(&LIB/CBDPRLPD) TOFILE(CHKDPRPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP)               /*S01417*/
/*                        MBROPT(*REPLACE)                            /*S01417*/
/**/
/**********  SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +                                 */ /*CPK018*/
/**********               MSGDTA('Validation of COB Component and +                    */ /*CPK018*/
/**********               Dependency files in ' *CAT &LIB *CAT +                       */ /*CPK018*/
/**********               'taking place') TOPGMQ(*EXT) MSGTYPE(*STATUS)                */ /*CPK018*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Validation of CoB Component and +
                          Dependency files in' *BCAT &LIB *BCAT +
                          'taking place') TOPGMQ(*EXT) MSGTYPE(*STATUS)                   /*CPK018*/
/**/
/************CALL*******PGM(CHKCOBRPG)                                /*S01417*/
/**/
/************IF*********COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01417*/
/****************SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('An + /*S01417*/
/***********************  error has been discovered during the +      /*S01417*/
/***********************  validation of the COB files. Check the +    /*S01417*/
/***********************  report CHKCOBP1 produced for details and +  /*S01417*/
/***********************  correct the files') TOPGMQ(*EXT)            /*S01417*/
/****************GOTO***    CMDLBL(END)                               /*S01417*/
/************ENDDO******                                              /*S01417*/
             CALL       PGM(CHKCOBRPG) PARM(&NOTVAL &LIB)             /*S01417*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01417*/
                        IF         COND(&NOTVAL *EQ 'Y') THEN(DO)     /*S01417*/
                                   SNDPGMMSG  MSGID(CPF9898) +
                                   MSGF(QCPFMSG) MSGDTA('A +
                                   Dependency Loop conflict has +
                                   occurred. See report CB9010P1') +
                                   TOPGMQ(*EXT)                       /*S01417*/
                        ENDDO                                         /*S01417*/
                        IF         COND(&NOTVAL *NE 'Y') THEN(DO)     /*S01417*/
                                   SNDPGMMSG  MSGID(CPF9898) +
                                   MSGF(QCPFMSG) MSGDTA('A Database +
                                   error has occurred. See report +
                                   CHKCOBP1') TOPGMQ(*EXT)            /*S01417*/
                        ENDDO                                         /*S01417*/
                        GOTO       CMDLBL(END)                        /*S01417*/
             ENDDO                                                    /*S01417*/
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Validation of COB files complete. +
                          The files are correct') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             DLYJOB     DLY(10)
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('A database error has occurred during +
                          the COB file validation processing - Job +
                          terminated.') TOPGMQ(*EXT) MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
