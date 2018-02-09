     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate BRT Tax Indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVTXIN01- Validate BRT Tax Indicator                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 22Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE007 - Base Rate Tax 2001                                  *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D BrtArr          S              1    DIM(5)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE007
      ** External DS for SAR Details                                                          CRE007
                                                                                              CRE007
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CRE007
      ** First DS for Access Programs, Short Data Structure                                   CRE007
                                                                                              CRE007
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      ** VALIDATION
      *
     C                   EXSR      VTXIN
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTXINOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VTXIN         BEGSR
 
      * Tax indicator must be L, N or P
     C     DDTXIN        IFNE      'L'
     C     DDTXIN        ANDNE     'N'
     C     DDTXIN        ANDNE     'P'
     C                   MOVE      'N'           DDTXINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR4164'     MsgIdXAr(Idx)
     C                   ENDIF
 
      * Store participant BRT liable flags in array
     C                   MOVEA     DD1BRT        BrtArr(1)
     C                   MOVEA     DD2BRT        BrtArr(2)
     C                   MOVEA     DD3BRT        BrtArr(3)
     C                   MOVEA     DD4BRT        BrtArr(4)
     C                   MOVEA     DD5BRT        BrtArr(5)
 
      * If at least 1 Y or N liable flag exists, set on corresponding flag
     C     'Y'           LOOKUP    BrtArr                                 90
     C                   MOVE      *IN90         YPresent          1
     C     'N'           LOOKUP    BrtArr                                 90
     C                   MOVE      *IN90         NPresent          1
 
      * Count the number of participants
     C                   Z-ADD     1             I                 1 0
     C     *BLANKS       LOOKUP    BrtArr(I)                              90
     C     I             SUB       1             I
 
 
      * For Account Holder Type R                                                             CRE007
     C     DDAHLT        IFEQ      'R'                                                        CRE007
                                                                                              CRE007
     C     NPresent      IFNE      '1'                                                        CRE007
     C                   MOVE      'N'           DD1BRTOK                                     CRE007
     C                   ADD       1             Idx                                          CRE007
     C                   MOVEL     'DD1BRT'      FldNamXAr(Idx)                               CRE007
     C                   MOVEL     'USR4611'     MsgIdXAr(Idx)                                CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
      * Post 5/4/01 R105 flag must be N or Y                                                  CRE007
     C     DDPSTR        IFNE      'N'                                                        CRE007
     C     DDPSTR        ANDNE     'Y'                                                        CRE007
     C                   MOVE      'N'           DDPSTROK                                     CRE007
     C                   ADD       1             Idx                                          CRE007
     C                   MOVEL     'DDPSTR'      FldNamXAr(Idx)                               CRE007
     C                   MOVEL     'USR4607'     MsgIdXAr(Idx)                                CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
     C                   GOTO      ENDVAL                                                     CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
      ** For account holder type J
     C     DDAHLT        IFEQ      'J'
 
      ** If not correct number of parties, return
     C     I             IFNE      2
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      * Post 5/4/01 R105 flag must be S or Blank                                              CRE007
     C     CRE007        IFEQ      'Y'                                                        CRE007
                                                                                              CRE007
     C     DDPSTR        IFNE      'S'                                                        CRE007
     C     DDPSTR        ANDNE     *BLANK                                                     CRE007
     C                   MOVE      'N'           DDPSTROK                                     CRE007
     C                   ADD       1             Idx                                          CRE007
     C                   MOVEL     'DDPSTR'      FldNamXAr(Idx)                               CRE007
     C                   MOVEL     'USR4606'     MsgIdXAr(Idx)                                CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
      * If tax indicator is P
     C     DDTXIN        IFEQ      'P'
 
      * One participant's liability must be N and the other Y
     C     YPresent      IFNE      '1'
     C     NPresent      ORNE      '1'
     C                   MOVE      'N'           DDTXINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR4159'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      * If Y and N entered, tax indicator must be P
     C     NPresent      IFEQ      '1'
     C     YPresent      ANDEQ     '1'
     C     DDTXIN        IFNE      'P'
     C                   MOVE      'N'           DDTXINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR4159'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      * Otherwise (i.e. account holder type I)
     C                   ELSE
 
      * If not correct number of parties, return
     C     I             IFEQ      2
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      * Post 5/4/01 R105 flag must be S or Blank                                              CRE007
     C     CRE007        IFEQ      'Y'                                                        CRE007
                                                                                              CRE007
     C     DDPSTR        IFNE      'S'                                                        CRE007
     C     DDPSTR        ANDNE     *BLANK                                                     CRE007
     C                   MOVE      'N'           DDPSTROK                                     CRE007
     C                   ADD       1             Idx                                          CRE007
     C                   MOVEL     'DDPSTR'      FldNamXAr(Idx)                               CRE007
     C                   MOVEL     'USR4606'     MsgIdXAr(Idx)                                CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
      * Tax indicator may not be P
     C     DDTXIN        IFEQ      'P'
     C                   MOVE      'N'           DDTXINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR4159'     MsgIdXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
 
      ** If tax indicator L no participant may be liability N
     C     DDTXIN        IFEQ      'L'
     C     NPresent      ANDEQ     '1'
     C                   MOVE      'N'           DDTXINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR4159'     MsgIdXAr(Idx)
     C                   ENDIF
 
      ** If tax indicator N no participant may be liability Y
     C     DDTXIN        IFEQ      'N'
     C     YPresent      ANDEQ     '1'
     C                   MOVE      'N'           DDTXINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR4159'     MsgIdXAr(Idx)
     C                   ENDIF
 
      ** At least 1 Y or N must be entered
     C     YPresent      IFEQ      '0'
     C     NPresent      ANDEQ     '0'
     C                   MOVE      'N'           DD1BRTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DD1BRT'      FldNamXAr(Idx)
     C                   MOVEL     'USR4174'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Account Holder Type
     C                   PARM                    DDAHLT            1
      ** Party 1 BRT Tax
     C                   PARM                    DD1BRT            1
      ** Party 2 BRT Tax
     C                   PARM                    DD2BRT            1
      ** Party 3 BRT Tax
     C                   PARM                    DD3BRT            1
      ** Party 4 BRT Tax
     C                   PARM                    DD4BRT            1
      ** Party 5 BRT Tax
     C                   PARM                    DD5BRT            1
      ** BRT Tax Indicator
     C                   PARM                    DDTXIN            1
      ** Post 5/4/01 R105                                                                     CRE007
     C                   PARM                    DDPSTR            1                          CRE007
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** BRT Tax Indicator - OK
     C                   PARM                    DDTXINOK          1
     C                   PARM                    DD1BRTOK          1
      *                                                                                       CRE007
      ** Post 5/4/01 R105 - OK                                                                CRE007
     C                   PARM                    DDPSTROK          1                          CRE007
      *                                                                                       CRE007
      ** Access SAR details to determine if Base Rate Tax 2001 is on                          CRE007
      *                                                                                       CRE007
     C                   CALLB     'AOSARDR0'                                                 CRE007
     C                   PARM      *BLANKS       @RTCD             7                          CRE007
     C                   PARM      '*VERIFY'     @OPTN             7                          CRE007
     C                   PARM      'CRE007'      @SARD             6                          CRE007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE007
      *                                                                                       CRE007
     C     @RTCD         IFEQ      *BLANKS                                                    CRE007
     C                   MOVEL     'Y'           CRE007            1                          CRE007
     C                   ELSE                                                                 CRE007
     C                   MOVEL     'N'           CRE007                                       CRE007
     C                   END                                                                  CRE007
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
