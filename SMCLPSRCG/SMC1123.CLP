/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Change owner, grant authority')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1123 - Change owner, grant authority                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 250022             Date 16Aug07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK023             Date 13Dec05              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       250022 - Reflect changes to CHGOWNAUT command.              */
/*       CPK023 - Add exception handling for ZZ* message files.      */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&LIB &CRTAUT &LOWNER &LOWNERAUT +                         */ /*CSC043*/
/**********               &LPUBLIC &LAUTL &OOWNER &OOWNERAUT +                         */ /*CSC043*/
/**********               &OPUBLIC &OAUTL)                                             */ /*CSC043*/
             PGM        PARM(&LIB &CRTAUT &LOWNER &LOWNERAUT +
                          &LPUBLIC &LAUTL &OOWNER &OOWNERAUT +
                          &OPUBLIC &OAUTL &ASP &ASPDEV)                                   /*CSC043*/
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CRTAUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LOWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LOWNERAUT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LPUBLIC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LAUTL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OOWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OOWNERAUT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OPUBLIC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OAUTL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(2)                                      /*CSC043*/
             DCL        VAR(&ASPDEV) TYPE(*CHAR) LEN(10)                                  /*CSC043*/
 
             DCL        VAR(&ASPF) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PAUTL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Set up parameters for library CHGOWNAUT. */
             IF         COND(&LAUTL *EQ '*NONE') THEN(DO)
                CHGVAR     VAR(&PAUTL) VALUE('*REVOKE')
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&PAUTL) VALUE(&LAUTL)
             ENDDO
 
             IF         COND(&ASP *EQ 'AD') THEN(DO)
                CHGVAR     VAR(&ASPF) VALUE('*ASPDEV')
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&ASPF) VALUE(&ASP)
             ENDDO
/**********  CHGOWNAUT  OBJ(QSYS/&LIB) OBJTYPE(*LIB) NEWOWN(&LOWNER) +                 */ /*CSC043*/
/**********               PUBAUT(&LPUBLIC) AUTL(&PAUTL) CHGLIB(N)                      */ /*CSC043*/
             CHGOWNAUT  OBJ(QSYS/&LIB) OBJTYPE(*LIB) NEWOWN(&LOWNER) +
                          PUBAUT(&LPUBLIC) AUTL(&PAUTL) CHGLIB(N) +
                          ASP(&ASPF) ASPDEV(&ASPDEV)                                      /*CSC043*/
 
/* Perform other authority changes if necessary. */
             IF         COND(&LOWNERAUT *NE '*ALL') THEN(DO)
                GRTOBJAUT  OBJ(QSYS/&LIB) OBJTYPE(*LIB) USER(&LOWNER) +
                          AUT(&LOWNERAUT)
             ENDDO
 
             CHGLIB     LIB(&LIB) CRTAUT(&CRTAUT)
 
/* Set up parameters for library contents CHGOWNAUT. */
             IF         COND(&OAUTL *EQ '*NONE') THEN(DO)
                CHGVAR     VAR(&PAUTL) VALUE('*REVOKE')
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&PAUTL) VALUE(&OAUTL)
             ENDDO
 
/**********  CHGOWNAUT  OBJ(&LIB/*ALL) OBJTYPE(*ALL) NEWOWN(&OOWNER) +                 */ /*CSC043*/
/**********               PUBAUT(&OPUBLIC) AUTL(&PAUTL) CHGLIB(N)                      */ /*CSC043*/
             CHGOWNAUT  OBJ(&LIB/*ALL) OBJTYPE(*ALL) NEWOWN(&OOWNER) +
                          PUBAUT(&OPUBLIC) AUTL(&PAUTL) CHGLIB(N) +
                          ASP(&ASPF) ASPDEV(&ASPDEV)                                      /*CSC043*/
 
/* Perform other authority changes if necessary. */
             IF         COND(&OOWNERAUT *NE '*ALL') THEN(DO)
                GRTOBJAUT  OBJ(&LIB/*ALL) OBJTYPE(*ALL) USER(&OOWNER) +
                          AUT(&OOWNERAUT)
             ENDDO
 
/**Special*processing*for*Output*Queues*and*Job*Queues.**/ /*                          */ /*250022*/
/**********  GRTOBJAUT  OBJ(&LIB/*ALL) OBJTYPE(*OUTQ) USER(&LOWNER) +                  */ /*250022*/
/**********               AUT(*ALL)                                                    */ /*250022*/
/**********  MONMSG     MSGID(CPF2253)                                                 */ /*250022*/
/**********  GRTOBJAUT  OBJ(&LIB/*ALL) OBJTYPE(*JOBQ) USER(&LOWNER) +                  */ /*250022*/
/**********               AUT(*ALL)                                                    */ /*250022*/
/**********  MONMSG     MSGID(CPF2253)                                                 */ /*250022*/
 
/* Exception handling for ZZ* message files.  If files are not present then */            /*CPK023*/
/*  the monitor message will allow the program to continue.                 */            /*CPK023*/
             GRTOBJAUT  OBJ(&LIB/ZZGBMSGF) OBJTYPE(*MSGF) +
                          USER(*PUBLIC) AUT(*USE)                                         /*CPK023*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK023*/
             GRTOBJAUT  OBJ(&LIB/ZZGBXXMSGF) OBJTYPE(*MSGF) +
                          USER(*PUBLIC) AUT(*USE)                                         /*CPK023*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK023*/
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGJOB     SWS(XXXXXX11)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
