import { useState } from "react";
import Modal, { ModalBody, ModalFooter } from '../Modal'
import PropTypes from 'prop-types';
import Notification from '../Notification';

// Components
import Button, { SecondaryButton } from '../Button';

// Services
import { updateSubscriber } from "../../services/subscriber";

const SubscriberStatusModal = (props) => {
  const { isOpen, onSuccess, onClose, subscriberId, status } = props;
  const [isUpdating, setIsUpdating] = useState(false)
  const [notification, setNotification] = useState({ isVisible: false, message: '', type: 'info' })

  const showNotification = (message, type = 'info') => {
    setNotification({ isVisible: true, message, type })
  }

  const hideNotification = () => {
    setNotification({ isVisible: false, message: '', type: 'info' })
  }

  const onUpdate = () => {
    const newStatus = status === 'active' ? 'inactive' : 'active'
    const payload = {
      status: newStatus
    }

    setIsUpdating(true)
    updateSubscriber(subscriberId, payload)
    .then((response) => {
      const actionText = newStatus === 'active' ? 'resubscribed' : 'unsubscribed'
      showNotification(`Subscriber ${actionText} successfully!`, 'success')
      onSuccess()
      onClose()
    })
    .catch((error) => {
      const errorMessage = error?.response?.data?.errors?.join(', ') || 
                          error?.response?.data?.message || 
                          'Something went wrong while updating the subscriber'
      showNotification(errorMessage, 'error')
    })
    .finally(() => {
      setIsUpdating(false)
    })
  }

  const modalTitleText = status === 'active' ? 
    "Unsubscribe" : "Resubscribe"
  const messageBodyText = status === 'active' ? 
    "Are you sure you'd like to unsubscribe this subscriber?" :
    "Are you sure you'd like to resubscribe this subscriber?"
  const buttonText = status === 'active' ? 
    "Unsubscribe" : "Resubscribe"

  return (
    <>
      <Notification
        isVisible={notification.isVisible}
        message={notification.message}
        type={notification.type}
        onClose={hideNotification}
      />
      <Modal modalTitle={modalTitleText} showModal={isOpen} onCloseModal={onClose}>
        <>
          <ModalBody>
            {messageBodyText}
          </ModalBody>
          <ModalFooter>
            <SecondaryButton
              className="mx-2"
              onClick={onClose}
            >
              Cancel
            </SecondaryButton>
            <Button
              type="primary"
              loading={isUpdating}
              onClick={onUpdate}
            >
              {buttonText}
            </Button>
          </ModalFooter>
        </>
      </Modal>
    </>
  );
};

SubscriberStatusModal.propTypes = {
  isOpen: PropTypes.bool,
  onClose: PropTypes.func,
  onSuccess: PropTypes.func,
  subscriberId: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
  status: PropTypes.string
}

export default SubscriberStatusModal;
