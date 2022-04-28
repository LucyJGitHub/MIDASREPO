/******************************************************************/                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  Midas - /COPY Member MSC3200                                  */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  LCI020_001 - Automated transmission processing                */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  Last Amend No. LCI020  *CREATE    Date 27Jul20                */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/******************************************************************/                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  LCI020 - Enable Inter.Pel transmission of SWIFT outgoing      */                      /*LCI020*/
/*           messages from Midas (Upgrade to FBM 2.1)             */                      /*LCI020*/
/******************************************************************/                      /*LCI020*/
                                                                                          /*LCI020*/
                IF         COND(&LCI020 *EQ 'Y') THEN(DO)                                 /*LCI020*/
                                                                                          /*LCI020*/
                 CHGVAR     VAR(&AFTCMD) VALUE(&DIR *TCAT 'ls ' *CAT +
                            &ENLPHO *CAT ' >/qsys.lib/' *CAT &PFX +
                            *CAT 'dplib.lib/mslistpd.file/mslistpd.mbr')                  /*LCI020*/
                 QSH        CMD(&AFTCMD)                                                  /*LCI020*/
                                                                                          /*LCI020*/
                 RMVM       FILE(XXLPCCPP) MBR(MX*)                                       /*LCI020*/
                 MONMSG     MSGID(CPF7301)                                                /*LCI020*/
                 CLRPFM     FILE(XXLPCCPP)                                                /*LCI020*/
                                                                                          /*LCI020*/
                 CALL       PGM(XXC020001) PARM(&ENLPHO &PFX)                             /*LCI020*/
                 IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                              /*LCI020*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                           /*LCI020*/
                   ROLLBACK                                                               /*LCI020*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)                               /*LCI020*/
                   GOTO       CMDLBL(END)                                                 /*LCI020*/
                 ENDDO       /*LCI020*/
                                                                                          /*LCI020*/
                 CALL       PGM(XX020001) PARM(&MSGS)                                     /*LCI020*/
                 IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                              /*LCI020*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                           /*LCI020*/
                   ROLLBACK                                                               /*LCI020*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)                               /*LCI020*/
                   GOTO       CMDLBL(END)                                                 /*LCI020*/
                 ENDDO       /*LCI020*/
                ENDDO       /*LCI020*/
                ELSE    CMD(DO)                                                           /*LCI020*/
                                                                                          /*LCI020*/
/*********************************************************************/                   /*LCI020*/
/* End of /COPY LCI020_001                                           */                   /*LCI020*/
/*********************************************************************/                   /*LCI020*/
