/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Create data areas for DMLIB only')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0276 - Create Data areas for DMLIB only                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CUT008              Date 09Feb11             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CUP008             Date 21Jul00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002             Date 28Apr99              */
/*                      CUP001 *CREATE     Date 06Aug98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUT008  - CRTOBJ rewrite.                                   */
/*                 Change of CRTOBJ parameters.                      */
/*       CUP008 - Create renames by using variable.                  */
/*       CUP002 - Additional monitoring of CRTOBJ.                   */
/*                If data area not from DMLIB continue processing.   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PTFSRC &DMLIBUPG &OWNER &AUTL +
                          &DMLIBMOV &RETURN)
 
             DCL        VAR(&PTFSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUTL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIBUPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIBMOV) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&USTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NEWNAM) TYPE(*CHAR) LEN(10)                                  /*CUP008*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(UPDLVCL6)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&RETURN) VALUE(' ')
             CHGVAR     VAR(&USTS) VALUE('C')
READNEXT:
             IF         COND(&AUMBNM *NE ' ') THEN(DO)
/*/COPY UPCPYSRC,C_UP0020A                                           */
             ENDDO
 
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              GOTO       CMDLBL(END)
             ENDDO
 
/* If data area not in DMLIB then ignore */
             IF         COND(%SST(&AUSRCF 9 2) *EQ 'DM') THEN(DO)
/* If data area does not already exist then ignore */
                CHKOBJ     OBJ(&DMLIBUPG/&AUMBNM) OBJTYPE(*DTAARA)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(READNEXT))
 
                MOVOBJ     OBJ(&DMLIBUPG/&AUMBNM) OBJTYPE(*DTAARA) +
                          TOLIB(&DMLIBMOV)
/* If object already exists then try to rename it and move again */
                MONMSG     MSGID(CPF2112) EXEC(DO)
/* If object already exists then try to rename it and move again */
/************      RNMOBJ     OBJ(&DMLIBMOV/&AUMBNM) OBJTYPE(*FILE) +                  */ /*CUP008*/
/************             NEWOBJ('#.' *TCAT &AUMBNM)                                   */ /*CUP008*/
                   CHGVAR     VAR(&NEWNAM) VALUE('#.' *TCAT &AUMBNM)                      /*CUP008*/
                   RNMOBJ     OBJ(&DMLIBMOV/&AUMBNM) OBJTYPE(*FILE) +
                          NEWOBJ(&NEWNAM)                                                 /*CUP008*/
                   MONMSG     MSGID(CPF2112) EXEC(DO)
                      CHGVAR     VAR(&USTS) VALUE('F')
                      GOTO       CMDLBL(READNEXT)
                   ENDDO
                   MOVOBJ     OBJ(&DMLIBUPG/&AUMBNM) OBJTYPE(*FILE) +
                          TOLIB(&DMLIBMOV)
                ENDDO
CRTOBJ:
/**********     CRTOBJ     SRCMBR(&AUMBNM) SRCFILE(&PTFSRC/&AUSRCF) +                  */ /*CUT008*/
/**********               PLIB(&DMLIBUPG) OWNER(&OWNER) AUTL(&AUTL)                    */ /*CUT008*/
                CRTOBJ     OBJ(&DMLIBUPG/&AUMBNM) +
                             SRCFILE(&PTFSRC/&AUSRCF) SRCMBR(*OBJ) +
                             OWNER(&OWNER) AUTL(&AUTL)                                    /*CUT008*/
/************   MONMSG     MSGID(SYS9898 SYS0011) EXEC(DO)         */ /*CUP002*/
                MONMSG     MSGID(SYS9898 SYS0011 SYS0017) EXEC(DO)    /*CUP002*/
                   CHGVAR     VAR(&USTS) VALUE('F')
                   GOTO       CMDLBL(READNEXT)
                ENDDO
 
                CPYDTAARA  FMDTAARA(&DMLIBMOV/&AUMBNM) +
                          TODTAARA(&DMLIBUPG/&AUMBNM)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CHGVAR     VAR(&USTS) VALUE('F')
                   GOTO       CMDLBL(READNEXT)
                ENDDO
 
                GOTO       CMDLBL(READNEXT)
 
             ENDDO
             ELSE       CMD(DO)                                                           /*CUP002*/
                GOTO       CMDLBL(READNEXT)                                               /*CUP002*/
             ENDDO                                                                        /*CUP002*/
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGVAR     VAR(&RETURN) VALUE('F')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
