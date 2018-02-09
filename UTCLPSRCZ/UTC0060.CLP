/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Identify hooks in source member')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - UT Module                                           */
/*                                                                   */
/*       UTC0060 - Identify hooks in source member                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP096             Date 21Mar05              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 28May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      118779             Date 23Jun97              */
/*                      CPK008             Date 13Feb97              */
/*                      103522             Date 22May96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP096 - Report is still picking up deleted /COPY statement */
/*       CSC017 - Change to 250 library list.                        */
/*       CPK015 - 4.01 packaging.  Change submit job USER.           */
/*       118779 - Override SRCFILE to QTEMP copy.                    */
/*       CPK008 - DBA R2 packaging:                                  */
/*              - Changes for source being 112 long.                 */
/*              - Changes to allow for ILE source types.             */
/*       103522 - Creating the variable for source file/library was  */
/*                moved so that the SBMJOB had correct values        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SRCM &SRCF &RPTTYPE &CPYTYPE &SBM +
                          &NOOFLINES &JOBQ)
 
             DCL        VAR(&SRCM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RPTTYPE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SBM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYTYPE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&NOOFLINES) TYPE(*DEC) LEN(2)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&SRCFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYSTRT) TYPE(*DEC) LEN(2)
             DCL        VAR(&CPYLEN) TYPE(*DEC) LEN(2)
             DCL        VAR(&SRCTYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSTCOPY) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CPYSTRTA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYLENA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&HDRTXT) TYPE(*CHAR) LEN(34)
             DCL        VAR(&HDRTXT1) TYPE(*CHAR) LEN(55)
/************DCL        VAR(&LIBLIST) TYPE(*CHAR) LEN(275)                             */ /*CSC017*/
/************DCL        VAR(&LIBLIST1) TYPE(*CHAR) LEN(253)                            */ /*CSC017*/
/************DCL        VAR(&LIBLIST2) TYPE(*CHAR) LEN(22)                             */ /*CSC017*/
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IN01) TYPE(*LGL)
 
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&SRCFILE) VALUE(%SST(&SRCF 1 10))         /*103522*/
             CHGVAR     VAR(&SRCL) VALUE(%SST(&SRCF 11 10))           /*103522*/
                                                                      /*103522*/
/* Check JOBD UTJOBD exists if batch job                        */
             IF         COND(&SBM = 'Y') THEN(DO)
                  CHKOBJ     OBJ(UTJOBD) OBJTYPE(*JOBD)
                  MONMSG     MSGID(CPF9801) EXEC(DO)
                       GOTO       CMDLBL(ABNOR)
                  ENDDO
             ENDDO
 
/* If not batch then process interactively */
             IF         COND((&SBM *NE 'Y') *AND (&SBM *NE 'y')) +
                          THEN(DO)
 
/************CHGVAR     VAR(&SRCFILE) VALUE(%SST(&SRCF 1 10)) */      /*103522*/
/************CHGVAR     VAR(&SRCL) VALUE(%SST(&SRCF 11 10))   */      /*103522*/
 
/* If no library specified then find where member is in library list */
             IF         COND(&SRCL *EQ '*LIBL') THEN(DO)
             CALL       PGM(UT0063) PARM(&SRCM &SRCFILE &SRCL &ERR)
             IF         COND(&ERR *EQ 'Y') THEN(GOTO CMDLBL(ABNOR))
             ENDDO
/* Retrive member attribute and set positions for OPNQRYF */
             RTVMBRD    FILE(&SRCL/&SRCFILE) MBR(&SRCM) +
                          SRCTYPE(&SRCTYPE)
 
/* Create header texts for reports */
             CHGVAR     VAR(&HDRTXT) VALUE(&SRCM *BCAT 'in' *BCAT +
                          &SRCL *TCAT '/' *TCAT &SRCFILE)
             CHGVAR     VAR(&HDRTXT1) VALUE(' ')
             CHGVAR     VAR(&HDRTXT1) VALUE('Source member ' *CAT +
                          &SRCM *BCAT 'found in ' *CAT &SRCL *TCAT +
                          '/' *TCAT &SRCFILE)
 
/* Retrieve user library list for first page of *LIST report */
/************RTVJOBA    USRLIBL(&LIBLIST)                                              */ /*CSC017*/
/************CHGVAR     VAR(&LIBLIST1) VALUE(%SST(&LIBLIST 1 253))                     */ /*CSC017*/
/************CHGVAR     VAR(&LIBLIST2) VALUE(%SST(&LIBLIST 254 22))                    */ /*CSC017*/
             SAVLIBL    SAVDTL(FHLL)                                                      /*CSC017*/
 
/* Call program to produce first page report details */
/************CALL       PGM(UT0062) PARM(&RPTTYPE &HDRTXT1 &LIBLIST1 +                 */ /*CSC017*/
/************             &LIBLIST2 &CPYTYPE &NOOFLINES &ERR)                          */ /*CSC017*/
             CALL       PGM(UT0062) PARM(&RPTTYPE &HDRTXT1 &CPYTYPE +
                          &NOOFLINES &ERR)                                                /*CSC017*/
 
     IF         COND(&CPYTYPE *EQ '*ALL') THEN(DO)
/* Set lengths of substrings for OPNQRYF */
             CHGVAR     VAR(&CPYLEN) VALUE(5)
/************IF         COND(&SRCTYPE *EQ 'RPG') THEN(DO)          */ /*CPK008*/
             IF         COND(&SRCTYPE *EQ 'RPG' *OR &SRCTYPE *EQ +
                          'RPGLE') THEN(DO)                           /*CPK008*/
                  CHGVAR     VAR(&CPYSTRT) VALUE(7)
             ENDDO
             ELSE       CMD(DO)
/************     IF    COND(&SRCTYPE *EQ 'CLP' *OR &SRCTYPE *EQ + */ /*CPK008*/
/************             'CMD') THEN(DO)                          */ /*CPK008*/
                  IF         COND(&SRCTYPE *EQ 'CLP' *OR &SRCTYPE *EQ +
                          'CLLE' *OR &SRCTYPE *EQ 'CMD') THEN(DO)     /*CPK008*/
                       CHGVAR     VAR(&CPYSTRT) VALUE(3)
                  ENDDO
                  ELSE       CMD(DO)
                       CHGVAR     VAR(&CPYSTRT) VALUE(8)
                  ENDDO
             ENDDO
     ENDDO
 
     IF         COND(&CPYTYPE *EQ '*HOOKS') THEN(DO)
/* Set lengths of substrings for OPNQRYF */
/**********  CHGVAR     VAR(&CPYLEN) VALUE(8)                                             /*CUP096*/
             CHGVAR     VAR(&CPYLEN) VALUE(14)                                            /*CUP096*/
/************IF         COND(&SRCTYPE *EQ 'RPG') THEN(DO)          */ /*CPK008*/
             IF         COND(&SRCTYPE *EQ 'RPG' *OR &SRCTYPE *EQ +
                          'RPGLE') THEN(DO)                           /*CPK008*/
/**********       CHGVAR     VAR(&CPYSTRT) VALUE(13)                                      /*CUP096*/
                  CHGVAR     VAR(&CPYSTRT) VALUE(7)                                       /*CUP096*/
             ENDDO
             ELSE       CMD(DO)
/************     IF    COND(&SRCTYPE *EQ 'CLP' *OR &SRCTYPE *EQ + */ /*CPK008*/
/************             'CMD') THEN(DO)                          */ /*CPK008*/
                  IF         COND(&SRCTYPE *EQ 'CLP' *OR &SRCTYPE *EQ +
                          'CLLE' *OR &SRCTYPE *EQ 'CMD') THEN(DO)     /*CPK008*/
/**********            CHGVAR     VAR(&CPYSTRT) VALUE(9)                                  /*CUP096*/
                       CHGVAR     VAR(&CPYSTRT) VALUE(3)                                  /*CUP096*/
                  ENDDO
                  ELSE       CMD(DO)
/**********            CHGVAR     VAR(&CPYSTRT) VALUE(14)                                 /*CUP096*/
                       CHGVAR     VAR(&CPYSTRT) VALUE(8)                                  /*CUP096*/
                  ENDDO
             ENDDO
     ENDDO
 
/*             Processing for *LIST type of report                   */
 
             IF         COND(&RPTTYPE *EQ '*LIST' *OR &RPTTYPE *EQ +
                          '*BOTH') THEN(DO)
 
/* Build string for mapfield */
                  CHGVAR     VAR(&CPYSTRTA) VALUE(&CPYSTRT)
                  CHGVAR     VAR(&CPYLENA) VALUE(&CPYLEN)
                  CHGVAR   VAR(&SSTCOPY) VALUE('%SST(1/SRCDTA ' *CAT +
                          &CPYSTRTA *CAT ' ' *CAT &CPYLENA *CAT ')')
 
/* Delete file if it already exists */
                  DLTF       FILE(QTEMP/HOOKS)
                  MONMSG     MSGID(CPF0000)
 
/*****************CRTPF FILE(QTEMP/HOOKS) RCDLEN(92) TEXT('Temporary +/*CPK008*/
/*****************        file for FINDHOOK')                         /*CPK008*/
 
                  CRTPF FILE(QTEMP/HOOKS) RCDLEN(112) TEXT('Temporary +
                          file for FINDHOOK')                         /*CPK008*/
 
                  OVRDBF     FILE(&SRCFILE) TOFILE(&SRCL/&SRCFILE) +
                          MBR(&SRCM) SHARE(*YES)
 
/* Depending on whether *HOOKS or all /COPYs requested perform the */
/* relevant OPNQRYF */
     IF         COND(&CPYTYPE *EQ '*ALL') THEN(DO)
                  OPNQRYF   FILE((&SRCL/&SRCFILE &SRCM)) QRYSLT('CPYF +
                          *EQ "/COPY"') KEYFLD((*MAPFLD/SRCDTA)) +
                          MAPFLD((CPYF &SSTCOPY *CHAR 5) (SRCDTA +
                          '%SST(1/SRCDTA 7 74)'))
     ENDDO
 
     IF         COND(&CPYTYPE *EQ '*HOOKS') THEN(DO)
/**********       OPNQRYF   FILE((&SRCL/&SRCFILE &SRCM)) QRYSLT('CPYF +                   /*CUP096*/
/**********               *EQ "WNCPYSRC"') KEYFLD((*MAPFLD/SRCDTA)) +                     /*CUP096*/
/**********               MAPFLD((CPYF &SSTCOPY *CHAR 8) (SRCDTA +                        /*CUP096*/
/**********               '%SST(1/SRCDTA 7 74)'))                                         /*CUP096*/
                 OPNQRYF    FILE((&SRCL/&SRCFILE &SRCM)) QRYSLT('CPYF +
                          *EQ "/COPY WNCPYSRC"') +
                          KEYFLD((*MAPFLD/SRCDTA)) MAPFLD((CPYF +
                          &SSTCOPY *CHAR 14) (SRCDTA '%SST(1/SRCDTA +
                          7 74)'))                                                        /*CUP096*/
     ENDDO
 
/* Copy selected records to temporary file; sorted by sourcefile and */
/* then by hook */
                  CPYFRMQRYF FROMOPNID(&SRCFILE) TOFILE(QTEMP/HOOKS) +
                          MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)
                  CLOF       OPNID(&SRCFILE)
                  DLTOVR     FILE(&SRCFILE)
 
/* Call program to produce list of hooks, sorted alphabetically */
             CALL       PGM(UT0060) PARM(&SRCTYPE &HDRTXT &CPYTYPE +
                          &ERR)
                  IF        COND(&ERR *EQ '1') THEN(GOTO CMDLBL(ABNOR))
             ENDDO
 
/*             Processing for *PLACE type of report                  */
 
             IF         COND(&RPTTYPE *EQ '*PLACE' *OR &RPTTYPE *EQ +
                          '*BOTH') THEN(DO)
/* Delete file if already exists */
                  DLTF       FILE(QTEMP/SRCFILE)
                  MONMSG     MSGID(CPF0000)
/* Create temporary sourcefile to be processed by RPG */
/*********        CRTSRCPF   FILE(QTEMP/SRCFILE) MBR(*FILE) +         /*CPK008*/
/*********                TEXT('Temporary source file for FINDHOOK')  /*CPK008*/
                  CRTSRCPF   FILE(QTEMP/SRCFILE) RCDLEN(112) +
                          MBR(*FILE) +
                          TEXT('Temporary source file for FINDHOOK')  /*CPK008*/
                  CPYF       FROMFILE(&SRCL/&SRCFILE) +
                          TOFILE(QTEMP/SRCFILE) FROMMBR(&SRCM) +
                          MBROPT(*REPLACE)
 
/* Override SRCFILE in QTEMP                                          /*118779*/
             OVRDBF    FILE(SRCFILE) TOFILE(QTEMP/SRCFILE)            /*118779*/
             CALL       PGM(UT0061) PARM(&NOOFLINES &HDRTXT +
                          &CPYTYPE &ERR)
             DLTOVR     FILE(SRCFILE)                                 /*118779*/
                  IF        COND(&ERR *EQ '2') THEN(GOTO CMDLBL(ABNOR))
             ENDDO
        ENDDO
 
/* If job is requested for batch then submit interactive call */
             IF         COND((&SBM *EQ 'Y') *OR (&SBM *EQ 'y')) +
                          THEN(DO)
/************SBMJOB     CMD(FINDHOOK SRCMBR(&SRCM) +                                   */ /*CPK015*/
/************             SRCFILE(&SRCL/&SRCFILE) RPTTYPE(&RPTTYPE) +                  */ /*CPK015*/
/************             CPYTYPE(&CPYTYPE) SUBM(N) +                                  */ /*CPK015*/
/************             NOOFLINES(&NOOFLINES)) JOB(&SRCM) +                          */ /*CPK015*/
/************             JOBD(UTJOBD) JOBQ(&JOBQ)                                     */ /*CPK015*/
             SBMJOB     CMD(FINDHOOK SRCMBR(&SRCM) +
                          SRCFILE(&SRCL/&SRCFILE) RPTTYPE(&RPTTYPE) +
                          CPYTYPE(&CPYTYPE) SUBM(N) +
                          NOOFLINES(&NOOFLINES)) JOB(&SRCM) +
                          JOBD(UTJOBD) JOBQ(&JOBQ) USER(*JOBD)                            /*CPK015*/
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             RCLRSC
 /* Send escape messages for errors in RPG programs */
             IF         COND(&ERR *EQ '1') THEN(DO)
                  SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Error in UT0060') +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
             IF         COND(&ERR *EQ '2') THEN(DO)
                  SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Error in UT0061') +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
 /* Recursive error */
             IF         COND(&IN01) THEN(DO)
 
                  SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Recursive error in pgm UTC0060') +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
             CHGVAR     VAR(&IN01) VALUE('1')
 
ABNOR2:
 /* Receive diagnostic error message */
             RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 
             IF         COND(&MSGID *NE ' ') THEN(DO)
 /* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       CMDLBL(ABNOR2)
             ENDDO
 /* Receive escape error message */
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 /* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
             ENDPGM
