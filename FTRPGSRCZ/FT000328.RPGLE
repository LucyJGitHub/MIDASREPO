     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Alpha Sequence Code Number')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000328 - Build Alphanumeric Sequence Code for FT Payments  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT151 *Create     Date 21Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D CHRS1           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D CHRS2           C                   '0123456789'
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Array containing Alphanumeric value
     D CHRSA           S              1    DIM(36) CTDATA PERRCD(36)
      *
     D**    Data Area For ordinary Payment Ref Numbering
     D OTPAYD        E DS                  EXTNAME(OTPAYDA)
     D WINPAY          DS
     D  INQNM                  1      4
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D*     Data structure for sequence code - INPUT
     DIPREF            DS             4
     D  W#I1                   1      1
     D  W#I2                   2      2
     D  W#I3                   3      3
     D  W#I4                   4      4
     D*     Data structure for sequence code - OUTPUT
     DOPREF            DS             4
     D  W#O1                   1      1
     D  W#O2                   2      2
     D  W#O3                   3      3
     D  W#O4                   4      4
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Create Sequence Code
      *
     C     WCALC         IFEQ      'A'
     C                   EXSR      SRAddSeq
     C                   ELSE
     C                   EXSR      SRSubSeq
     C                   END
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation Processing                           *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
     C     *DTAARA       DEFINE    INPAYDA       WINPAY
     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD
     C                   Z-ADD     36            W#LIM             2 0
      *
      * If Payment type is not supported
     C     I@OTIN        IFNE      'OT'
     C     I@OTIN        ANDNE     'IN'
     C                   MOVE      '*ERROR'      O@RTCD
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAddSeq   Add one to alphanumeric code                      *
      *                                                               *
      *****************************************************************
      *
     C     SRAddSeq      BEGSR
      *
      * Read data area - Outgoing
      *
     C     I@OTIN        IFEQ      'OT'
      *
     C     *LOCK         IN        OTPAYD
     C                   MOVE      OSQNM         IPREF
     C                   ENDIF
      *
      * Read data area - Incoming
      *
     C     I@OTIN        IFEQ      'IN'
      *
     C     *LOCK         IN        WINPAY
     C                   MOVE      INQNM         IPREF
     C                   ENDIF
      *
     C                   MOVE      IPREF         OPREF
     C                   MOVE      IPREF         O@SEQD
     C     CHRS1         CAT       CHRS2         CHRS             36
      *
      *  Add 1 to indexes
      *
     C     W#I4          SCAN      CHRS:1        IDX4              2 0
     C                   ADD       1             IDX4
      *
     C     IDX4          IFLE      W#LIM
     C                   MOVE      CHRSA(IDX4)   W#O4
     C                   ELSE
     C                   Z-ADD     1             IDX4
     C                   MOVE      CHRSA(IDX4)   W#O4
     C     W#I3          SCAN      CHRS:1        IDX3              2 0
     C                   ADD       1             IDX3
      *
     C     IDX3          IFLE      W#LIM
     C                   MOVE      CHRSA(IDX3)   W#O3
     C                   ELSE
     C                   Z-ADD     1             IDX3
     C                   MOVE      CHRSA(IDX3)   W#O3
     C     W#I2          SCAN      CHRS:1        IDX2              2 0
     C                   ADD       1             IDX2
      *
     C     IDX2          IFLE      W#LIM
     C                   MOVE      CHRSA(IDX2)   W#O2
     C                   ELSE
     C                   Z-ADD     1             IDX2
     C                   MOVE      CHRSA(IDX2)   W#O2
     C     W#I1          SCAN      CHRS:1        IDX1              2 0
     C                   ADD       1             IDX1
      *
      * If Payment type is not supported
     C     IDX1          IFGT      W#LIM
     C                   MOVE      '*ERROR'      O@RTCD
     C                   RETURN
     C                   END
      *
     C                   MOVE      CHRSA(IDX1)   W#O1
      *
     C                   END
     C                   END
     C                   END
      *
      * Read data area - Outgoing
     C     I@OTIN        IFEQ      'OT'
     C     WUPD          ANDEQ     'Y'
     C                   MOVE      OPREF         OSQNM
     C                   OUT       OTPAYD
     C                   END
      *
      * Read data area - Incoming
     C     I@OTIN        IFEQ      'IN'
     C     WUPD          ANDEQ     'Y'
     C                   MOVE      OPREF         INQNM
     C                   OUT       WINPAY
     C                   END
     C                   MOVE      OPREF         N@SEQD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSubSeq   Sub one to alphanumeric code                      *
      *                                                               *
      *****************************************************************
      *
     C     SRSubSeq      BEGSR
      *
      * Read data area - Outgoing
      *
     C     I@OTIN        IFEQ      'OT'
      *
     C     *LOCK         IN        OTPAYD
     C                   MOVE      OSQNM         IPREF
     C                   ENDIF
      *
      * Read data area - Incoming
      *
     C     I@OTIN        IFEQ      'IN'
      *
     C     *LOCK         IN        WINPAY
     C                   MOVE      INQNM         IPREF
     C                   ENDIF
      *
     C                   MOVE      IPREF         OPREF
     C                   MOVE      IPREF         O@SEQD
     C     CHRS1         CAT       CHRS2         CHRS             36
      *
      *  Sub 1 to indexes
      *
     C     W#I4          SCAN      CHRS:1        IDX4              2 0
     C                   SUB       1             IDX4
      *
     C     IDX4          IFGT      0
     C                   MOVE      CHRSA(IDX4)   W#O4
     C                   ELSE
     C                   Z-ADD     36            IDX4
     C                   MOVE      CHRSA(IDX4)   W#O4
     C     W#I3          SCAN      CHRS:1        IDX3              2 0
     C                   SUB       1             IDX3
      *
     C     IDX3          IFGT      0
     C                   MOVE      CHRSA(IDX3)   W#O3
     C                   ELSE
     C                   Z-ADD     36            IDX3
     C                   MOVE      CHRSA(IDX3)   W#O3
     C     W#I2          SCAN      CHRS:1        IDX2              2 0
     C                   SUB       1             IDX2
      *
     C     IDX2          IFGT      0
     C                   MOVE      CHRSA(IDX2)   W#O2
     C                   ELSE
     C                   Z-ADD     36            IDX2
     C                   MOVE      CHRSA(IDX2)   W#O2
     C     W#I1          SCAN      CHRS:1        IDX1              2 0
     C                   SUB       1             IDX1
      *
      * If Payment type is not supported
     C     IDX1          IFLE      0
     C                   MOVE      '*ERROR'      O@RTCD
     C                   RETURN
     C                   END
      *
     C                   MOVE      CHRSA(IDX1)   W#O1
      *
     C                   END
     C                   END
     C                   END
      *
      * Read data area - Outgoing
     C     I@OTIN        IFEQ      'OT'
     C     WUPD          ANDEQ     'Y'
     C                   MOVE      OPREF         OSQNM
     C                   OUT       OTPAYD
     C                   END
      *
      * Read data area - Incoming
     C     I@OTIN        IFEQ      'IN'
     C     WUPD          ANDEQ     'Y'
     C                   MOVE      OPREF         INQNM
     C                   OUT       WINPAY
     C                   END
     C                   MOVE      OPREF         N@SEQD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
     C                   PARM                    O@RTCD            7
     C                   PARM                    I@OTIN            2
     C                   PARM                    WCALC             1
     C                   PARM                    WUPD              1
     C                   PARM                    O@SEQD            4
     C                   PARM                    N@SEQD            4
      *
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  CHRSA
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
